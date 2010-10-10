class CreateResultMethods < ActiveRecord::Migration
  def self.up
    create_table :result_methods do |t|
      t.string  :name,        :length => 255, :key => true
      t.integer :calls
      t.float   :total_time
      t.float   :self_time
      
      t.references :result_thread

      t.timestamps
    end
  end

  def self.down
    drop_table :result_methods
  end
end
