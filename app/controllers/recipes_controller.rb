class RecipesController < ApplicationController
  respond_to :html, :js
  # Added to restrict non-logged in individuals from adding recipes
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => [:create,:update]

	before_action :prepareOptions, only: [:new, :create, :show, :find_by_culture, :find_by_ingredients,:index,:sort, :edit,:update]
  def index
    @recipes = Recipe.order(favCount: :desc).all
    @sort_type="favs"
    @current_state= "Down"
  
  end

  def prepareOptions
  	@meat = ["Beef", "Chicken", "Pork", "Tofu", "Turkey", "Eggs"]
  	@vegetables = ["Artchoke Hearts", "Broccoli", "Carrot", "Corn", "Peas", "Spinach", "Tomato","Green Onions","Cucumber"]
  	@spices= ["Salt", "Pepper", "Tumeric", "Whole Garlic", "Garlic Powder"]
    @misc= ["Cheese", "Cream", "Oil", "Pasta", "Sauce", "Wine", "Herbs", "Rice", "Citrus"]
  	@cultures = ["American", "Chinese", "Greek", "Indian", "Italian", "Japanese", "Kosher", "Mexican", "Thai"]
  	@options = ["Nut Free", "Veg Friendly", "Gluten Free", "Shellfish"]
  	@main_option = ["Meat","Vegetables", "Spice", "Misc" ]
  	@meat_serving = ["pieces", "oz", "pounds","whole"]
  	@veg_serving = ["cups", "cloves", "ounces", "tablespoons", "teaspoons","whole", "pieces","pinch"]
    @choices = {"main"=>@meat, "veg"=>@vegetables, "spice"=>@spices, "misc"=>@misc}
    @servings = {"main"=>@meat_serving, "veg"=>@veg_serving, "spice"=>@veg_serving, "misc"=>@veg_serving,"none"=>(@veg_serving+@meat_serving)}
  end

  def new
  	@recipe = Recipe.new
  	@recipe.steps.build
    @recipe.culture=""
    @recipe.options=""
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    flash[:notice]="Recipe Deleted!"
    redirect_to recipes_path
  end

  def update
    @recipe = Recipe.find(params[:id])
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
      @recipe.ingredients.build(:ing_type=>'main')
    elsif params[:Veg]
      @recipe.ingredients.build(:ing_type=>'veg')
    elsif params[:Spice]
      @recipe.ingredients.build(:ing_type=>'spice')
    elsif params[:Misc]
      @recipe.ingredients.build(:ing_type=>'misc')
    elsif params[:FreeForm]
      @recipe.ingredients.build(:ing_type=>"none")
    else
      if @recipe.culture==""
        puts "in culutre if"
        flash[:notice] = "Please select a culture."
        render action: 'edit'
        return
      end
     
      if params[:steps].blank? and @recipe.steps.blank?
        puts "steps if"
        flash[:notice]="Please include at least one step"
        render action: 'edit'
        return
      end
      if params[:ingredients].blank? and @recipe.ingredients.blank?
        puts "ingredient check"
        flash[:notice]="Please include at least one  ingredient"
        render action: 'edit'
        return
      end 

      if @recipe.source==""
        flash[:notice]="Who is the source?"
        render action: 'edit'
        return
      end

      if @recipe.update(recipe_params)
        check_ingredients(@recipe.ingredients).each do |bad_ing|
          @recipe.ingredients.destroy(bad_ing)
        end
        check_steps(@recipe.steps).each do |bad_step|
          @recipe.steps.destroy(bad_step)
        end
        redirect_to @recipe and return
      else
        render 'edit'
      end
    end
    puts "made it to end"
    render :action => 'edit'

  end

  def edit
    @recipe = Recipe.find(params[:id])

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
          @recipes = Recipe.order(favCount: :desc).where(:culture=>params[:culture].split("/")).where(:options=>params[:options])
        else
          @recipes = Recipe.order(favCount: :desc).where(:culture=>params[:culture].split("/"))
        end
      else
        unless params[:options] =="None"
          @recipes = Recipe.order(favCount: :desc).where(:options=>params[:options])
        else
          @recipes = Recipe.order(favCount: :desc).all
        end
      end
      @sort_type="favs"
      @current_state= "Down"
      format.html{render action: 'show_multiple'}
      format.js{render action: 'show_multiple'}
    end
  end

  def find_by_ingredients

    param = params[:name].split('/')
    if params[:name]=="None" and params[:options]=="None"
      @recipes = Recipe.order(favCount: :desc).all
    else
      @recipes=[]
      unless params[:options]=="None"
        options = params[:options].split('/')
        ids_2 = Recipe.order(favCout: :desc).where(:options=>params[:options]).pluck(:id)
      else
        culture=[]
        ids_2=Recipe.order(favCount: :desc).pluck(:id)
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
    end
    @sort_type="favs"
    @current_state= "Down"

    render 'show_multiple'
  end



  def create
    
  	@recipe = Recipe.new(recipe_params)
    puts @recipe.id
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
    elsif params[:FreeForm]
      @recipe.ingredients.build(:ing_type=>"none")
    else
      if @recipe.culture==""
        puts "in culutre if"
        flash[:notice] = "Please select a culture."
       render :action => 'new' and return
      end
      check_steps(@recipe.steps).each do |bad_step|
          @recipe.steps.delete(bad_step)
      end
      if params[:steps].blank? and @recipe.steps.blank?
        puts "steps if"
        flash[:notice]="Please include at least one step"
        render :action => 'new' and return
      end

      check_ingredients(@recipe.ingredients).each do |bad_ing|
        @recipe.ingredients.delete(bad_ing)
      end
      if params[:ingredients].blank? and @recipe.ingredients.blank?
        puts "ingredient check"
        flash[:notice]="Please include at least one  ingredient"
        render :action => 'new' and return
      end 

      if @recipe.source==""
        flash[:notice]="Who is the source?"
        render :action => 'new' and return
        
      end


      #Add @recipe.owner_id = something
      #if current_user
        @recipe.owner_id = current_user.id
      #else
      #  redirect_to new_user_session_path, notice: 'You are not logged in.'
      #end 

      if @recipe.save
        redirect_to @recipe and return
      end
      
      puts "check something"
    end
  
    puts "made it to the end"
    render :action => 'new'
   
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


  def editFavorites
    @recipe=Recipe.find(params[:id])
    if current_user.fav_recipes
      if current_user.fav_recipes.include? params[:id]
        @recipe.favCount-=1
        holder = current_user.fav_recipes.split(',').to_a
        holder.delete(params[:id])
        current_user.fav_recipes = holder.join(',')
        flash[:notice] = "Recipe Removed From Favorites"
      else
        if @recipe.favCount
          @recipe.favCount+=1
        else
          @recipe.favCount = 1
        end
        holder = current_user.fav_recipes.split(',').to_a
        holder.push(params[:id])
        current_user.fav_recipes = holder.join(',')
        flash[:notice] = "Recipe Added to Favorites"
      end
    else
      current_user.fav_recipes = params[:id]+","
      if @recipe.favCount
        @recipe.favCount+=1
      else
        @recipe.favCount = 1
      end
      flash[:notice] = "Recipe Added to Favorites"
    end
    @recipe.save
    @current_user.save

    redirect_to :back
    
  end

  def getFavorites
    ids = current_user.fav_recipes.split(',')
    @recipes =Recipe.find(ids.map(&:to_i))
    @current_state = "down"
    @sort_type = "favs"
    
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
