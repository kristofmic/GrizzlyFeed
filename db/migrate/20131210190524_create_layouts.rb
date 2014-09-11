class CreateLayouts < ActiveRecord::Migration
  def change
    create_table :layouts do |t|
      t.string :name
      t.string :icon

      t.timestamps
    end

    add_index :layouts, :name, unique: true

    add_column :users, :layout_id, :integer
  end
end
