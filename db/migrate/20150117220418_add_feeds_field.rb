class AddFeedsField < ActiveRecord::Migration
  def change
  	add_column :recipes, :feeds, :integer
  end
end
