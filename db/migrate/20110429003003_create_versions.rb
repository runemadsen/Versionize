class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.string :name
      t.string :alias
      t.integer :idea_id
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
