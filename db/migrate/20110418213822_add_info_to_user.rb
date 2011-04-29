class AddInfoToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :website, :string
    add_column :users, :location, :string
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :website
    remove_column :users, :location
  end
end
