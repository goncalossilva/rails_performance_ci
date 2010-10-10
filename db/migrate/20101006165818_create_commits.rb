class CreateCommits < ActiveRecord::Migration
  def self.up
    create_table :commits do |t|
      t.string    :hash,    :null => false, :length => 32
      t.string    :message, :length => 255
      t.string    :author,  :length => 255
      t.timestamp :date
      
      t.references :application

      t.timestamps
    end
  end

  def self.down
    drop_table :commits
  end
end
