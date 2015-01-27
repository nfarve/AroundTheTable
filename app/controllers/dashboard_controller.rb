class DashboardController < ApplicationController
	respond_to :html, :js
	before_filter :authenticate_user!
 
 	before_action :prepareOptions, only: [:find_by_culture, :index]

  	def index
  		@recipes= Recipe.all
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

    def surprise
    redirect_to Recipe.offset(rand(Recipe.count)).first
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

end
