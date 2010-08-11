class Thread < ActiveRecord::Base
  belongs_to :test
  has_many :methods
end
