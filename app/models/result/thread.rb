class Result::Thread < ActiveRecord::Base
  belongs_to :test, :class_name => "Result::Test"
  has_many :methods, :class_name => "Result::Method"
end
