class RecipesController < ApplicationController
  layout "recipe_layout", only: [:index, :show, :query]
  # Added to restrict non-logged in individuals from adding recipes
  before_filter :authenticate_user!

	before_action :prepareOptions, only: [:new, :create,:layout]
  def index
    @recipe= Recipe.all
  
  end

  def prepareOptions
  	@meat = ["Beef", "Chicken", "Pork", "Tofu", "Turkey"]
  	@vegetables = ["Artchoke Hearts", "Brocolli", "Carrot", "Corn", "Peas", "Spinach", "Tomato"]
  	@spices= ["Salt", "Pepper", "Tumeric", "Whole Garlic", "Garlic Powder"]
    @misc= ["Cheese", "Cream", "Olive Oil", "Pasta", "Soy Sauce", "Wine"]
  	@cultures = ["American", "Chinese", "Greek", "Indian", "Italian", "Japanese", "Kosher", "Mexican", "Thai"]
  	@options = ["Includes Peanuts", "Veg Friendly", "Gluten Free", "Shellfish"]
  	@main_option = ["Meat","Vegetables", "Spice", "Misc" ]
  	@meat_serving = ["pieces", "oz", "pounds"]
  	@veg_serving = ["cups", "cloves", "ounces", "tablespoons", "teaspoons"]
    @choices = {"main"=>@meat, "veg"=>@vegetables, "spice"=>@spices, "misc"=>@misc}
    @servings = {"main"=>@meat_serving, "veg"=>@veg_serving, "spice"=>@veg_serving, "misc"=>@veg_serving}
  end

  def new
  	@recipe = Recipe.new
  	@recipe.steps.build
  end
  	
  def show
   
    @recipe = Recipe.find(params[:id])
  end

  def find_by_desc
   
    param = params[:name].split('/')
    @recipes=[]
    b = Hash.new(0)
    ids= Ingredient.where(:name=>param)
    puts ids.size
    ids.each do |v|
      #puts v.recipe_id, b[v.recipe_id]
      
      b[v.recipe_id] += 1
      
     # puts param.size
    end

    b.each do |key,array|
      puts "#{key}"
      puts array
      integer = "#{key}".to_i
      if array >= param.size
         @recipes.push(Recipe.find(integer))
      end
    end
    

    render 'show_multiple'
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
