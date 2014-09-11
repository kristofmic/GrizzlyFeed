class AddEntriesToUserFeed < ActiveRecord::Migration
  def change
    add_column :user_feeds, :entries, :integer, default: 5
  end
end
