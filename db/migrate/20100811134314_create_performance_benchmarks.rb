class CreatePerformanceBenchmarks < ActiveRecord::Migration
  def self.up
    create_table :performance_benchmarks do |t|
      t.float :total_time

      t.timestamps
    end
  end

  def self.down
    drop_table :performance_benchmarks
  end
end
