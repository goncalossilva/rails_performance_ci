class CreatePerfMethodAssociations < ActiveRecord::Migration
  def self.up
    create_table :perf_method_associations do |t|
      t.integer :parent_id
      t.integer :child_id
    end
  end

  def self.down
    drop_table :perf_method_associations
  end
end
