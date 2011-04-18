class AddInfoToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :website, :string
    add_column :users, :location, :string
  end

  def self.down
    remove_column :ideas, :name
    remove_column :ideas, :website
    remove_column :ideas, :location
  end
end
