class CreatePerfDifferences < ActiveRecord::Migration
  def self.up
    create_table :perf_differences do |t|
      t.string :prev_commit
      t.string :curr_commit
      t.references :prev_method
      t.references :curr_method
      t.float :difference
    end
  end

  def self.down
    drop_table :perf_differences
  end
end
