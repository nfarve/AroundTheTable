class RecipesController < ApplicationController
  respond_to :html, :js
  # Added to restrict non-logged in individuals from adding recipes
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => :create

	before_action :prepareOptions, only: [:new, :create, :show, :find_by_culture, :find_by_ingredients,:index,:sort]
  def index
    @recipes= Recipe.all
    @recipes=Recipe.sort_by_specifics(@recipes.to_a, "timeUp")
    @sort_type="time"
    @current_state= "Down"
  
  end

  def prepareOptions
  	@meat = ["Beef", "Chicken", "Pork", "Tofu", "Turkey"]
  	@vegetables = ["Artchoke Hearts", "Broccoli", "Carrot", "Corn", "Peas", "Spinach", "Tomato"]
  	@spices= ["Salt", "Pepper", "Tumeric", "Whole Garlic", "Garlic Powder"]
    @misc= ["Cheese", "Cream", "Olive Oil", "Pasta", "Soy Sauce", "Wine"]
  	@cultures = ["American", "Chinese", "Greek", "Indian", "Italian", "Japanese", "Kosher", "Mexican", "Thai"]
  	@options = ["Nut Free", "Veg Friendly", "Gluten Free", "Shellfish"]
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
  	
  def forma
    respond_to do |format|
      if params[:culture]
        @cultures=params[:culture]
       
      else
          @cultures = "None"
      end
      if params[:options]
        @options=params[:options]
      else
        @options="None"
      end


      format.html{render :action=> :querya, :culture=>@cultures,:options=>@options}
      format.js{redirect_to querya_path(:culture=>@cultures, :options=>@options)}
    end

  end

  def formb
    respond_to do |format|
      puts params[:name]
      if params[:name]
        @names=params[:name]
      else
          @names = "None"
      end
      if params[:options]
        @options=params[:options]
      else
        @options="None"
      end
      format.html {redirect_to queryb_path(:name=>@names,:options=>@options) }
      format.js{redirect_to queryb_path(:name=>@names,:options=>@options)}
    end
  end

  def show
   
    @recipe = Recipe.find(params[:id])
  end

  def find_by_culture
    respond_to do |format|
      unless params[:culture]=="None"
     
        unless params[:options] =="None"
          @recipes = Recipe.where(:culture=>params[:culture].split("/")).where(:options=>params[:options])
        else
          @recipes = Recipe.where(:culture=>params[:culture].split("/"))
        end
      else
        unless params[:options] =="None"
          @recipes = Recipe.where(:options=>params[:options])
        else
          @recipes = Recipe.all
        end
      end
      @recipes=Recipe.sort_by_specifics(@recipes.to_a, "timeUp")
      @sort_type="time"
      @current_state= "Down"
      format.html{render action: 'show_multiple'}
      format.js{render action: 'show_multiple'}
    end
  end

  def find_by_ingredients

    param = params[:name].split('/')
    @recipes=[]
    unless params[:options]=="None"
      options = params[:options].split('/')
      ids_2 = Recipe.where(:options=>params[:options]).pluck(:id)
    else
      culture=[]
      ids_2=*(1..Recipe.all.size)
    end
    b = Hash.new(0)
    ids= Ingredient.where(:name=>param)
 
    ids.each do |v|
      #puts v.recipe_id, b[v.recipe_id]
      if ids_2.include? v.recipe_id
        b[v.recipe_id] += 1
      end
      
     # puts param.size
    end

    b.each do |key,array|
      integer = "#{key}".to_i
      if array >= param.size
         @recipes.push(Recipe.find(integer))
      end
    end
    @recipes=Recipe.sort_by_specifics(@recipes.to_a, "timeUp")
    @sort_type="time"
    @current_state= "Down"

    render 'show_multiple'
  end



  def create
    
  	@recipe = Recipe.new(recipe_params)
    
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
        render action: 'new'
        return
      end
      check_steps(@recipe.steps).each do |bad_step|
          @recipe.steps.delete(bad_step)
      end
      if params[:steps].blank? and @recipe.steps.blank?
        puts "steps if"
        flash[:notice]="Please include at least one step"
        render action: 'new'
        return
      end

      check_ingredients(@recipe.ingredients).each do |bad_ing|
        @recipe.ingredients.delete(bad_ing)
      end
      if params[:ingredients].blank? and @recipe.ingredients.blank?
        puts "ingredient check"
        flash[:notice]="Please include at least one  ingredient"
        render action: 'new'
        return
      end 

      if @recipe.source==""
        flash[:notice]="Who is the source?"
        render action: 'new'
        return
      end


      #Add @recipe.owner_id = something 

      if @recipe.save
        redirect_to @recipe
        return
      else
        puts "failed save"
        render action: 'new'
        return
      end
      puts "check something"
    end
  
    puts "made it to the end"
    render action: 'new'
   
  end

  def sort
    @recipes = Recipe.find(params[:recipe].split('/').map(&:to_i))
    puts params[:sort_type]+params[:current_state]
    @recipes=Recipe.sort_by_specifics(@recipes, params[:sort_type]+params[:current_state])
    @sort_type = params[:sort_type]
    if params[:current_state]=='Up'
      @current_state = "Down"
    else
      @current_state = "Up"
    end
    render action: 'show_multiple'
  end

  def surprise
    redirect_to Recipe.offset(rand(Recipe.count)).first

  end

  private
  def recipe_params
    #params.require(:recipe).permit(:name, :feeds, :time)
    params.require(:recipe).permit(:name,:feeds, :time,:cost,:skill, :Main, :Veg,:Spice,:Misc,:add_step,:source,
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
