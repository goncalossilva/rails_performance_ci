class AddCommitToPerfBenchmark < ActiveRecord::Migration
  def self.up
    add_column :perf_benchmarks, :commit, :string
  end

  def self.down
    remove_column :perf_benchmarks, :commit
  end
end
