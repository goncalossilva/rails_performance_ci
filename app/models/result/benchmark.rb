class Result::Benchmark < ActiveRecord::Base
  belongs_to :commit
  has_many :tests, :class_name => "Result::Test"
end
