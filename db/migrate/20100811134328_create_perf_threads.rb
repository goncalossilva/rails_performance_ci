class CreatePerfThreads < ActiveRecord::Migration
  def self.up
    create_table :perf_threads do |t|
      t.integer :thread_id, :null => false
      t.float :total_time, :null => false
      t.references :perf_test, :null => false
    end
  end

  def self.down
    drop_table :perf_threads
  end
end
