class CreateUserFeeds < ActiveRecord::Migration
  def change
    create_table :user_feeds do |t|
      t.belongs_to :feed
      t.belongs_to :user

      t.timestamps
    end

    add_index :user_feeds, [:user_id, :feed_id], unique: true
  end
end
