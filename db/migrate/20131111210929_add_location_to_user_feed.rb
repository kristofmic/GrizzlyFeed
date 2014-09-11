class AddLocationToUserFeed < ActiveRecord::Migration
  def change
    add_column :user_feeds, :column, :integer, default: 0
    add_column :user_feeds, :row, :integer, default: 0
  end
end
