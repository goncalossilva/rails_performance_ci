class PerfBenchmark < ActiveRecord::Base
  belongs_to :app
  has_many :perf_tests, :dependent => :destroy
  
  after_create :check_benchmark_history
  
  validates :date, :presence => true
  validates :app, :presence => true
  validates :commit, :presence => true, :uniqueness => true 
  
  def differences(other)
    differences = {:better => {}, :worse => {}}
    methods = Array.new
    other_methods = Array.new
    
    self.perf_tests.includes(:perf_threads => :perf_methods).each do |test|
      test.perf_threads.each do |thread|
        methods.concat(thread.perf_methods)
      end
    end
    
    other.perf_tests.includes(:perf_threads => :perf_methods).each do |test|
      test.perf_threads.each do |thread|
        other_methods.concat(thread.perf_methods)
      end
    end

    methods.each do |method|
      name = method.name
      perf_test = method.perf_thread.perf_test
      other_method = other_methods.find { |el| el.name == name and el.perf_thread.perf_test.name == perf_test.name }
      next if other_method.nil?
      
      diff = method.self_time - other_method.self_time
      if diff > other_method.self_time * 0.1 # TODO: should this be configurable?
        differences[:worse].merge!({name => diff})
      elsif -diff > method.self_time * 0.1 # TODO: should this be configurable?
        differences[:better].merge!({name => -diff})
      end
    end
    
    differences
  end
  
  private
  
  def check_benchmark_history
    app = self.app
    perf_benchmarks = app.perf_benchmarks
    perf_benchmarks.first.delete if perf_benchmarks.size > app.benchmark_history and app.benchmark_history > 0
    
    true
  end
end
