class CreatePerfMethods < ActiveRecord::Migration
  def self.up
    create_table :perf_methods do |t|
      t.string :name, :null => false
      t.integer :calls
      t.float :total_time
      t.float :self_time
      t.references :perf_thread
    end
  end

  def self.down
    drop_table :methods
  end
end
