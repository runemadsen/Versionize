class AddAccessToIdeas < ActiveRecord::Migration
  def self.up
    add_column :ideas, :access, :integer, :default => 0
  end

  def self.down
    remove_column :ideas, :access
  end
end
