class CreateThreads < ActiveRecord::Migration
  def self.up
    create_table :threads do |t|
      t.integer :thread_id
      t.float :total_time

      t.timestamps
    end
  end

  def self.down
    drop_table :threads
  end
end
