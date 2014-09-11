class AddActionsToUserFeedEntry < ActiveRecord::Migration
  def change
    add_column :user_feed_entries, :viewed, :boolean, default: false
    add_column :user_feed_entries, :marked_as_viewed, :boolean, default: false
  end
end
