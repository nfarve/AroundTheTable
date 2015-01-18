class AddForeignKey < ActiveRecord::Migration
  def change
  	add_column :steps, :recipe_id, :integer
  	add_column :ingredients, :recipe_id, :integer
  end
end
