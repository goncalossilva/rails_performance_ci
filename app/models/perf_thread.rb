class PerfThread < ActiveRecord::Base
  belongs_to :perf_test
  has_many :perf_methods
  
  validates :thread_id, :presence => true
  validates :total_time, :presence => true
  validates :perf_test, :presence => true
end
