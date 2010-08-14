class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.string :name, :null => false
      t.string :repository, :null => false
      t.string :frequency, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :perf_apps
  end
end
