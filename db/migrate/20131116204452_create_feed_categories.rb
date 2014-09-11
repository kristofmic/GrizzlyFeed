class CreateFeedCategories < ActiveRecord::Migration
  def change
    create_table :feed_categories do |t|
      t.belongs_to :category
      t.belongs_to :feed

      t.timestamps
    end
    add_index :feed_categories, [:category_id, :feed_id], unique: true
  end
end
