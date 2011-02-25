class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.string  :name,      :null => false, :unique => true
      t.string  :permalink, :null => false, :unique => true
      t.string  :uri,       :null => false, :length => 255
      t.string  :branch,    :default => "master"
      t.boolean :public,    :default => false
      t.string  :token,     :null => false, :length => 16

      t.timestamps
    end
  end

  def self.down
    drop_table :applications
  end
end
