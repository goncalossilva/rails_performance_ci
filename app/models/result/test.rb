class Result::Test < ActiveRecord::Base
  belongs_to :benchmark, :class_name => "Result::Benchmark"
  has_many :threads, :class_name => "Result::Thread"
end
