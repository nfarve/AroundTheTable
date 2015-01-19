class RecipesController < ApplicationController

  # Added to restrict non-logged in individuals from adding recipes
  before_filter :authenticate_user!

	before_action :prepareOptions, only: [:new, :create]
  def index
    @recipe= Recipe.all
  end

  def prepareOptions
  	@meat = ["Chicken", "Beef", "Turkey"]
  	@vegetables = ["Brocolli", "Carrot", "Corn", "Peas"]
  	@spices= ["Salt", "Pepper", "Tumeric","Garlic Powder"]
  	@cultures = ["American", "Chinese", "Greek"]
  	@options = ["Includes Peanuts", "Veg Friendly", "Gluten Free"]
  	@main_option = ["Meat","Vegetables", "Spice", "Misc" ]
  	@meat_serving = ["pieces", "oz", "pounds"]
  	@veg_serving = ["cups", "tablespoons", "teaspoons"]
    @choices = {"main"=>@meat, "veg"=>@vegetables, "spice"=>@spices}
    @servings = {"main"=>@meat_serving, "veg"=>@veg_serving, "spice"=>@veg_serving}
  end

  def new
  	@recipe = Recipe.new
  	@recipe.steps.build
  end
  	
  def show
    @recipe = Recipe.find(params[:id])
  end


  def create
    
  	@recipe = Recipe.new(recipe_params)
  
  	if params[:add_step]
      	# add empty step associated with @recipe
      	@recipe.steps.build
    elsif params[:Main]
        @recipe.ingredients.new(:ing_type=>'main')
    elsif params[:Veg]
        @recipe.ingredients.build(:ing_type=>'veg')
    elsif params[:Spice]
        @recipe.ingredients.build(:ing_type=>'spice') 
    elsif params[:Misc]
        @recipe.ingredients.build(:ing_type=>'misc')
    else
      if params[:culture].blank?
        flash[:notice] = "Please select a culture."
        render :action => 'new' and return
      else
        culture_keywords = params[:culture]
        @recipe.culture = culture_keywords.join(",")
      end
      if params[:options].blank?
        @recipe.options=""
      else
        options_keywords = params[:options]
        @recipe.options = options_keywords.join(",")
      end
      if @recipe.save
        redirect_to @recipe and return
      else
        render 'new' and return
      end
    end
      render :action => 'new'
  end

  private
  def recipe_params
    #params.require(:recipe).permit(:name, :feeds, :time)
    params.require(:recipe).permit!
  end
end
