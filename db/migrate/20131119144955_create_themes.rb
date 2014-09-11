class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
    	t.string :name

      t.timestamps
    end
    add_index :themes, :name, unique: true

    add_column :users, :theme_id, :integer
  end
end
