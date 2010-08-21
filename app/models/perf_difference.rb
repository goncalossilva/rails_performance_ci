class PerfDifference < ActiveRecord::Base
  belongs_to :prev_method, :class_name => "PerfMethod"
  belongs_to :curr_method, :class_name => "PerfMethod"
end
