class ChangeFieldName < ActiveRecord::Migration
  def change
  	rename_column :ingredients, :type, :ing_type
  end
end
