class RemoveFieldNameFromTableName < ActiveRecord::Migration
  def change
  	change_table :recipes do |t|
    	t.remove :ingredients_main, :ingredients_veg, :ingredients_spice, :ingredients_misc
    end
  end
end
