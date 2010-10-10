class Result::Method < ActiveRecord::Base
  belongs_to :thread, :class_name => "Result::Thread"
end
