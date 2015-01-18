class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :type
      t.string :name
      t.string :quantity
      t.string :quantity_description
      t.string :description

      t.timestamps null: false
    end
  end
end
