class PerfTest < ActiveRecord::Base
  belongs_to :perf_benchmark
  has_many :perf_threads
  
  validates :name, :presence => true
  validates :total_time, :presence => true
  validates :perf_benchmark, :presence => true
end
