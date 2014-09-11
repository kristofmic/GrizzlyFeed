class AddWelcomeToUser < ActiveRecord::Migration
  def change
    add_column :users, :welcome_stage, :integer, default: 1
  end
end
