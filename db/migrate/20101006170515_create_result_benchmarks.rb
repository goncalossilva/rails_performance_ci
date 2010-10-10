class CreateResultBenchmarks < ActiveRecord::Migration
  def self.up
    create_table :result_benchmarks do |t|
      t.text    :output,      :default => "", :length => 1048576
      t.boolean :successful,  :default => false
      t.float   :total_time
      
      t.references :commit

      t.timestamps
    end
  end

  def self.down
    drop_table :result_benchmarks
  end
end
