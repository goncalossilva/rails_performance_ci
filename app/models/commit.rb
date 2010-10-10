class Commit < ActiveRecord::Base
  belongs_to :application
  has_one :benchmark, :class_name => "Result::Benchmark"
end
