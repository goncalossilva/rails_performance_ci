class PerfMethod < ActiveRecord::Base
  belongs_to :perf_thread
  
  has_many :perf_method_associations_as_parent, :foreign_key => :parent_id, :class_name => "PerfMethodAssociation", :dependent => :destroy
  has_many :perf_method_associations_as_child, :foreign_key => :child_id, :class_name => "PerfMethodAssociation", :dependent => :destroy
  
  has_many :children, :through => :perf_method_associations_as_parent, :dependent => :destroy
  has_many :parents, :through => :perf_method_associations_as_child, :dependent => :destroy
    
  validates :name, :presence => true
end
