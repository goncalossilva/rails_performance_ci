class Child < ActiveRecord::Base
  belongs_to :parent, :class_name => Method
  belongs_to :child, :class_name => Method
end
