class CreateFeedErrors < ActiveRecord::Migration
  def change
    create_table :feed_errors do |t|
      t.string :url
      t.string :error

      t.timestamps
    end
  end
end
