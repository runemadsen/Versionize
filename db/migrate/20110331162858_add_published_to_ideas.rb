class AddPublishedToIdeas < ActiveRecord::Migration
  def self.up
    add_column :ideas, :published, :boolean, :default => true
  end

  def self.down
    remove_column :ideas, :published
  end
end
