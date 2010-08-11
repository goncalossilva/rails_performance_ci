class CreateChildren < ActiveRecord::Migration
  def self.up
    create_table :children, :id => false do |t|
      t.references :parent
      t.references :child
    end
  end

  def self.down
    drop_table :children
  end
end
