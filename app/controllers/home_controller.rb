class HomeController < ApplicationController
	
	# redirect user to dashboard if signed in
	def index
	    if user_signed_in?
	      redirect_to :controller=>'dashboard', :action => 'index'
	    end
  	end

end
