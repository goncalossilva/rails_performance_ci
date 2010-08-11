class Method < ActiveRecord::Base
  belongs_to :thread
  has_many :children, :foreign_key => :parent_id
  has_many :methods, :through => :children, :source => :child
end
