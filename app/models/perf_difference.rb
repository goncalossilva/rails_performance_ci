class PerfDifference < ActiveRecord::Base
  belongs_to :prev_method, :class_name => "PerfMethod"
  belongs_to :curr_method, :class_name => "PerfMethod"
  
  validates :prev_commit, :presence => true
  validates :curr_commit, :presence => true
  validates :test_name, :presence => true
  validates :prev_method, :presence => true
  validates :curr_method, :presence => true
  validates :difference, :presence => true
end
