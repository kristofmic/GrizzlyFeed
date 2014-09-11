class CreateUserFeedEntries < ActiveRecord::Migration
  def change
    create_table :user_feed_entries do |t|
      t.belongs_to :user
      t.belongs_to :feed_entry
      t.boolean :visited, default: false

      t.timestamps
    end
    add_index :user_feed_entries, [:user_id, :feed_entry_id], unique: true
  end
end
