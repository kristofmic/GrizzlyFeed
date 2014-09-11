class ChangeGuidToText < ActiveRecord::Migration
  def change
    change_column :feed_entries, :guid, :text
  end
end
