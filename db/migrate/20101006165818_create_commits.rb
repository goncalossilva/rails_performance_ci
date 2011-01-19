class CreateCommits < ActiveRecord::Migration
  def self.up
    create_table :commits do |t|
      t.string    :sha1,    :null => false, :length => 40
      t.string    :message, :length => 255
      t.string    :author,  :length => 255
      t.timestamp :time
      
      t.references :application

      t.timestamps
    end
  end

  def self.down
    drop_table :commits
  end
end
