class Test < ActiveRecord::Base
  belongs_to :run
  has_many :theads
end
