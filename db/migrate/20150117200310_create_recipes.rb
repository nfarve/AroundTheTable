class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :culture
      t.string :time
      t.string :procedure
      t.string :options
      t.string :cost
      t.string :skill
      t.integer :favCount

      t.timestamps null: false
    end
  end
end
