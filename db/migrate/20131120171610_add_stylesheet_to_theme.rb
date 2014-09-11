class AddStylesheetToTheme < ActiveRecord::Migration
  def change
  	add_column :themes, :stylesheet, :string
  end
end
