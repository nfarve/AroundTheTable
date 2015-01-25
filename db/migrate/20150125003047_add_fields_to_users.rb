class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthday, :date
    add_column :users, :culture, :string
    add_column :users, :option, :string
    add_column :users, :fav_recipes, :string
    add_column :users, :fav_ingredients, :string
    add_column :recipes, :owner_id, :integer
  end
end
