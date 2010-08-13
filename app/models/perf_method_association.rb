class PerfMethodAssociation < ActiveRecord::Base
  belongs_to :parent, :class_name => "PerfMethod"
  belongs_to :child, :class_name => "PerfMethod"
end
