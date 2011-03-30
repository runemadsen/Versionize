class CreateCollaborations < ActiveRecord::Migration
  def self.up
    create_table :collaborations do |t|
      t.integer :idea_id
      t.integer :user_id
      t.boolean :owner, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :collaborations
  end
end
