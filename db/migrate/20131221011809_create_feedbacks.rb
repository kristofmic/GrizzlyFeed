class CreateFeedbacks < ActiveRecord::Migration
  def change
    drop_table :feedbacks 
    
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.string :title
      t.text :message

      t.timestamps
    end
  end
end
