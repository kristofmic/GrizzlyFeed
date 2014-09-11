class CreateFeedEntryCategories < ActiveRecord::Migration
  def change
    create_table :feed_entry_categories do |t|
      t.belongs_to :category
      t.belongs_to :feed_entry

      t.timestamps
    end

    add_index :feed_entry_categories, [:category_id, :feed_entry_id], unique: true
  end
end
