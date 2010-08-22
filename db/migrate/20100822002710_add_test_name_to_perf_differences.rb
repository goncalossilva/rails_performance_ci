class AddTestNameToPerfDifferences < ActiveRecord::Migration
  def self.up
    add_column :perf_differences, :test_name, :string
  end

  def self.down
    remove_column :perf_differences, :test_name
  end
end
