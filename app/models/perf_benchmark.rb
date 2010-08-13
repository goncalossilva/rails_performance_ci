class PerfBenchmark < ActiveRecord::Base
  belongs_to :app
  has_many :perf_tests
  
  validates :date, :presence => true
  validates :app, :presence => true
end
