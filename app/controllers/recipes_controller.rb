class RecipesController < ApplicationController
  respond_to :html, :js
  # Added to restrict non-logged in individuals from adding recipes
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => :create

	before_action :prepareOptions, only: [:new, :create, :show, :find_by_desc, :index]
  def index
    @recipe= Recipe.all
  
  end

  def prepareOptions
  	@meat = ["Beef", "Chicken", "Pork", "Tofu", "Turkey"]
  	@vegetables = ["Artchoke Hearts", "Broccoli", "Carrot", "Corn", "Peas", "Spinach", "Tomato"]
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
    @recipe.culture=""
    @recipe.options=""
    respond_to do |format|
      format.html
      format.json
    end
  end
  	
  def form
    puts params[:name]
    if params[:name]
      @names=params[:name]
    else
        flash[:notice] = "Please select at least one ingredient."
        redirect_to(:back) and return
    end
    if params[:culture]
      @culture=params[:culture]
    end

    redirect_to query_path(:name=>@names,:culture=>@culture)

  end


  def show
   
    @recipe = Recipe.find(params[:id])
  end

  def find_by_desc
    
    param = params[:name].split('/')
    @recipes=[]
    if params[:culture]
      culture = params[:culture].split('/')
    else
      culture=[]
    end
    ids_2=[]
    b = Hash.new(0)
    ids= Ingredient.where(:name=>param)
    recipe = Recipe.where(:culture=>culture)
    if recipe.size>0
      recipe.each do |r|
        ids_2.push(r.id)
      end
    else
      ids_2=*(1..Recipe.all.size)
    end
   
    puts ids_2
    puts ids.size
    ids.each do |v|
      #puts v.recipe_id, b[v.recipe_id]
      if ids_2.include? v.recipe_id
        b[v.recipe_id] += 1
      end
      
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
    respond_to do |format|
      if params[:culture]
        culture_keywords = params[:culture]
        @recipe.culture = (culture_keywords.join(","))
      else
        @recipe.culture=""
      end
      if params[:options]
        options_keywords = params[:options]
        @recipe.options = options_keywords.join(",")
      else
        @recipe.options=""
      end
      
    	if params[:add_step]
          puts "add step called"
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
        if @recipe.culture==""
          puts "in culutre if"
          flash[:notice] = "Please select a culture."
          format.html { render action: 'new' }
          format.js { render action: 'new'}
          return
        end
        check_steps(@recipe.steps).each do |bad_step|
            @recipe.steps.delete(bad_step)
        end
        if params[:steps].blank? and @recipe.steps.blank?
          puts "steps if"
          flash[:notice]="Please include at least one step"
          format.html { render action: 'new' }
          format.js { render action: 'new'}
          return
        end

        check_ingredients(@recipe.ingredients).each do |bad_ing|
          @recipe.ingredients.delete(bad_ing)
        end
        if params[:ingredients].blank? and @recipe.ingredients.blank?
          puts "ingredient check"
          flash[:notice]="Please include at least one  ingredient"
          format.html { render action: 'new' }
          format.js{ render action: 'new'}
          return
        end

        if @recipe.save
          format.js 
          return
        else
          puts "failed save"
          format.html { render action: 'new' }
          format.js { render action: 'new'}
          return
        end
        puts "check something"
      end
    
      puts "made it to the end"
      format.html { render action: 'new' }
      format.js { render action: 'new'}
        
    end
   
  end

  private
  def recipe_params
    #params.require(:recipe).permit(:name, :feeds, :time)
    params.require(:recipe).permit(:name,:feeds, :time,:cost,:skill, :Main, :Veg,:Spice,:Misc,:add_step,
       steps_attributes: [:id, :description, :recipe_id], ingredients_attributes: [:id, :ing_type, :name, :quantity, :quantity_description, :description])
  end
  def check_steps(steps)
    bad_step = []
    steps.each do |step|
      if step.description==""
        bad_step.push(step)
      end
    end
    return bad_step
  end
  def check_ingredients(ingredients)
    bad_ingredient = []
    ingredients.each do |ing|
      if ing.quantity==""
        bad_ingredient.push(ing)
      end
    end
    return bad_ingredient
  end


end
