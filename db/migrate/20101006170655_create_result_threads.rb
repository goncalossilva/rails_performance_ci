class CreateResultThreads < ActiveRecord::Migration
  def self.up
    create_table :result_threads do |t|
      t.integer :thread_id,   :null => false
      t.float   :total_time
      
      t.references :result_test

      t.timestamps
    end
  end

  def self.down
    drop_table :result_threads
  end
end
