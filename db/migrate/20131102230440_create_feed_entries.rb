class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string :title
      t.string :url
      t.string :author
      t.text :summary
      t.text :content
      t.datetime :published_at
      t.string :guid
      t.belongs_to :feed

      t.timestamps
    end
    add_index :feed_entries, :guid
  end
end
