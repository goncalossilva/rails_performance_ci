class Application < ActiveRecord::Base
  has_many :commits
  
  def root
    "#{self.class.root}/#{permalink}"
  end
  
  def self.root
    Rails.root + "vendor/apps"
  end
end
