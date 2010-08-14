require "#{Rails.root}/lib/test_app"
require "#{Rails.root}/lib/cron"

class App < ActiveRecord::Base
  has_many :perf_benchmarks, :dependent => :destroy
  
  after_save :check_scheduling
  
  validates :name, :presence => true, :uniqueness => true
  validates :repository, :presence => true, :uniqueness => true
  validates :frequency, :presence => true
  
  # Called by the cron job
  def run_performance_benchmark
    results = nil
    
    with_proper_environment do
      ta = TestApp.new("vendor/apps/#{self.name}", self.repository)
      
      # clone/update application and necessary gems, run tests and import results
      #ta.setup
      ta.run_tests
      results = ta.read_results
    end
    
    import_results(results)
  end
  
  private
  
  def check_scheduling
    Cron.new(self.name, self.frequency)
  end
  
  def with_proper_environment
    # Bundler hack (to "bundle install" in vendor/apps/*)
    old_rubyopt = ENV["RUBYOPT"]
    old_gemfile = ENV["BUNDLE_GEMFILE"]
    ENV.delete("RUBYOPT")
    ENV.delete("BUNDLE_GEMFILE")
    
    old_railsenv = ENV["RAILS_ENV"]
    ENV["RAILS_ENV"] = "development"
    
    yield
    
    ENV["RUBYOPT"] = old_rubyopt
    ENV["BUNDLE_GEMFILE"] = old_gemfile
    ENV["RAILS_ENV"] = old_railsenv
  end
  
  def import_results(results)
    # import the data into the database
    ActiveRecord::Base.transaction do
      pb = PerfBenchmark.create!({:date => Time.now,
                                  :app => self,
                                  :total_time => 0.0,
                                  :commit => results[:commit]})
      
      results[:data].each do |ts_name, ts_data|
        ts = PerfTest.create!({:name => File.basename(ts_name.gsub(/(.+)_[^_]+/, "\\1")),
                              :total_time => ts_data["total_time"],
                              :perf_benchmark => pb})
        
        ts_data["threads"].each do |th_id, th_data|
          th = PerfThread.create!({:thread_id => th_id,
                                  :total_time => th_data["total_time"],
                                  :perf_test => ts})
          
          th_data["methods"].each do |mt_name, mt_data|
            if not th_data["methods"][mt_name].has_key?(:created_as_child)
              mt = PerfMethod.new({:name => mt_name,
                                  :calls => mt_data["calls"],
                                  :total_time => mt_data["total_time"],
                                  :self_time => mt_data["self_time"],
                                  :perf_thread => th})
            else
              mt = th.perf_methods.find_by_name(mt_name)
              mt.calls = mt_data["calls"]
              mt.total_time = mt_data["total_time"]
              mt.self_time = mt_data["self_time"]
            end
            
            mt_data["children"].each do |child_name|
              child = th.perf_methods.find_by_name(child_name)
              if child.nil?
                child = PerfMethod.create!({:name => child_name, :perf_thread => th})
                th_data["methods"][child_name].merge!(:created_as_child => true)
              end
              
              mt.children << child
              mt.save!
            end unless mt_data["children"].nil?
          end
        end
        
        pb.total_time += ts.total_time
        stack = ts_name.gsub(/(.+)_[^_]+/, "\\1_stack")
        FileUtils.mv("#{Rails.root}/#{stack}.html", "#{Rails.root}/public/assets/stack/#{ts.id}.html")
        FileUtils.rm("#{Rails.root}/#{ts_name}.yml")
      end

      pb.save!
    end
  end
end
