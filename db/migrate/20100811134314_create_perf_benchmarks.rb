class CreatePerfBenchmarks < ActiveRecord::Migration
  def self.up
    create_table :perf_benchmarks do |t|
      t.float :total_time
      t.date :date, :null => false
      t.references :app, :null => false
    end
  end

  def self.down
    drop_table :performance_benchmarks
  end
end
