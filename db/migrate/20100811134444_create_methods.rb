class CreateMethods < ActiveRecord::Migration
  def self.up
    create_table :methods do |t|
      t.string :name
      t.integer :calls
      t.float :total_time
      t.float :self_time

      t.timestamps
    end
  end

  def self.down
    drop_table :methods
  end
end
