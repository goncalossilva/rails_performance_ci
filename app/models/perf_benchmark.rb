class PerfBenchmark < ActiveRecord::Base
  belongs_to :app
  has_many :perf_tests, :dependent => :destroy
  
  after_create :check_benchmark_history
  
  validates :date, :presence => true
  validates :app, :presence => true
  validates :commit, :presence => true, :uniqueness => true
  
  private
  
  def check_benchmark_history
    app = self.app
    perf_benchmarks = app.perf_benchmarks
    perf_benchmarks.first.delete if perf_benchmarks.size > app.benchmark_history and app.benchmark_history > 0
    
    true
  end
end
