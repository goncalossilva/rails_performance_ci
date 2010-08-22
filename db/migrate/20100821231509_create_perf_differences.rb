class CreatePerfDifferences < ActiveRecord::Migration
  def self.up
    create_table :perf_differences do |t|
      t.string :prev_commit, :null => false
      t.string :curr_commit, :null => false
      t.references :prev_method, :null => false
      t.references :curr_method, :null => false
      t.float :difference, :null => false
    end
  end

  def self.down
    drop_table :perf_differences
  end
end
