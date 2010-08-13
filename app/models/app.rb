class App < ActiveRecord::Base
  has_many :performance_benchmarks
  
  after_save :check_scheduling
  
  validates :name, :presence => true, :uniqueness => true
  validates :repository, :presence => true, :uniqueness => true
  validates :frequency, :presence => true
  
  # Called by the cron job
  def run_performance_benchmark
    with_proper_environment do
      ta = TestApp.new("vendor/apps/#{self.name}", self.repository)
      
      # clone/update application and necessary gems, run tests and import results
      #ta.setup
      #ta.run_tests
      results = ta.read_results
      
      import_results(results)
    end
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
      pb = PerfBenchmark.create!({:date => Time.now, :app => self})
      
      results.each do |ts_name, ts_data|
        ts = pb.perf_tests.create!({:name => File.basename(ts_name),
                                    :total_time => ts_data["total_time"],
                                    :perf_benchmark => pb})
        
        ts_data["threads"].each do |th_id, th_data|
          th = ts.perf_threads.create!({:thread_id => th_id,
                                        :total_time => th_data["total_time"],
                                        :perf_test => ts})
          
          th_data["methods"].each do |mt_name, mt_data|
            # Hack: Rails 3 doesn't support th.perf_methods.find_or_create_by_name(name, *hash*)
            mt = PerfMethod.find_or_create_by_name_and_perf_thread_id
                                                  ({:name => mt_name,
                                                    :calls => mt_data["calls"],
                                                    :total_time => mt_data["total_time"],
                                                    :self_time => mt_data["self_time"],
                                                    :perf_thread => th})
                                                    
            children = mt_data["children"] || []
            children.each do |child|
              mt.children << th.perf_methods.find_or_create_by_name(child)
            end
          end
        end
        
        File.move("#{ts_name}.html", "#{Rails.root}/public/assets/stack/#{ts.id}.html")
        File.delete("#{ts_name}.yml")
      end
    
      pb.update_attribute(:total_time, pb.perf_tests.inject { |total, pt| total += pt.total_time })
    end
  end
end
