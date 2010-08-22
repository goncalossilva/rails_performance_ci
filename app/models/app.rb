require "#{Rails.root}/lib/test_app"
require "#{Rails.root}/lib/cron"

class App < ActiveRecord::Base
  has_many :perf_benchmarks, :dependent => :destroy
  
  after_save :check_scheduling
  
  validates :name, :presence => true, :uniqueness => true
  validates :repository, :presence => true, :uniqueness => true
  validates :frequency, :presence => true
  validates :threshold, :presence => true
  
  # Called by the cron job
  def run_performance_benchmark
    results = nil
    
    with_proper_environment do
      ta = TestApp.new("vendor/apps/#{self.name}", self.repository)
      
      # clone/update application and necessary gems, run tests and import results
      ta.setup
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
      pb = PerfBenchmark.create!({:date       => Time.now,
                                  :app        => self,
                                  :total_time => 0.0,
                                  :commit     => results[:commit]})
      
      results[:data].each do |ts_name, ts_data|
        ts = PerfTest.create!({:name => File.basename(ts_name.gsub(/(.+)_[^_]+/, "\\1")),
                              :total_time     => ts_data["total_time"],
                              :perf_benchmark => pb})
        
        ts_data["threads"].each do |th_id, th_data|
          th = PerfThread.create!({:thread_id => th_id,
                                  :total_time => th_data["total_time"],
                                  :perf_test  => ts})
          
          root = th_data["methods"].first
          
          insert_new_method(root[0], root[1], th_data["methods"], th)
        end
        
        pb.total_time += ts.total_time
        stack = ts_name.gsub(/(.+)_[^_]+/, "\\1_stack")
        FileUtils.mv("#{Rails.root}/#{stack}.html", "#{Rails.root}/public/assets/stack/#{ts.id}.html")
        FileUtils.rm("#{Rails.root}/#{ts_name}.yml")
      end

      pb.save!
    end
  end
  
  def insert_new_method(name, data, methods, thread)
    return thread.perf_methods.where(:name => name).select(:id, :name).first if data.nil?
    
    m = PerfMethod.create!({:name         => name,
                            :calls        => data["calls"],
                            :total_time   => data["total_time"],
                            :self_time    => data["self_time"],
                            :perf_thread  => thread})
    
    methods.delete(name)
                        
    data["children"].each do |child|
      m.children << insert_new_method(child, methods[child], methods, thread)
    end unless data["children"].nil?
    
    m
  end
end
