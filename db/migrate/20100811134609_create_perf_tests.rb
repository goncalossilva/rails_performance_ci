class CreatePerfTests < ActiveRecord::Migration
  def self.up
    create_table :perf_tests do |t|
      t.string :name, :null => false
      t.float :total_time, :null => false
      t.references :perf_benchmark, :null => false
    end
  end

  def self.down
    drop_table :perf_tests
  end
end
