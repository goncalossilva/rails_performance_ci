class AddThresholdToApp < ActiveRecord::Migration
  def self.up
    add_column :apps, :threshold, :float
  end

  def self.down
    remove_column :apps, :threshold
  end
end
