class AddFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.string :title
      t.text :message

      t.timestamps
    end
  end
end
