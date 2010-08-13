class AddBenchmarkHistoryToApp < ActiveRecord::Migration
  def self.up
    add_column :apps, :benchmark_history, :integer, :default => 0
  end

  def self.down
    remove_column :apps, :benchmark_history
  end
end
