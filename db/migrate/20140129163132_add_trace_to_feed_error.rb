class AddTraceToFeedError < ActiveRecord::Migration
  def change
    add_column :feed_errors, :trace, :text
  end
end
