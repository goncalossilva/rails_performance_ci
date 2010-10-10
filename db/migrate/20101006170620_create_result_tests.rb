class CreateResultTests < ActiveRecord::Migration
  def self.up
    create_table :result_tests do |t|
      t.string  :name,        :null => false, :length => 255
      t.float   :total_time
      
      t.references :result_benchmark

      t.timestamps
    end
  end

  def self.down
    drop_table :result_tests
  end
end
