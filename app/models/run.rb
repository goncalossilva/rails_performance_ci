class Run < ActiveRecord::Base
  belongs_to :performance_benchmark
  has_many :tests
end
