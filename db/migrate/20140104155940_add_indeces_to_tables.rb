class AddIndecesToTables < ActiveRecord::Migration
  def change
    add_index :feed_entries, :feed_id
  end
end
