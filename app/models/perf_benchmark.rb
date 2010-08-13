class PerfBenchmark < ActiveRecord::Base
  belongs_to :app
  has_many :perf_tests, :dependent => :destroy
  
  validates :date, :presence => true
  validates :app, :presence => true
end
