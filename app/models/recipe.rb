class Recipe < ActiveRecord::Base
	has_many :ingredients
	has_many :steps
	accepts_nested_attributes_for :ingredients, :allow_destroy => true
	accepts_nested_attributes_for :steps, :allow_destroy => true
	validates :name, presence: true


	def self.sort_by_specifics(array, type)
		case type
		when "skillUp"
		 	array.sort!  do |a, b| 
		 		case 
		 		when a.skill==b.skill 
		 			0 
		 		when a.skill =="Beginner"
		 			-1
		 		when (a.skill =="Intermediate" and b.skill=="Advance")
		 			-1
		 		when (a.skill=="Intermediate" and b.skill=="Beginner")
		 			1
		 		when a.skill=="Advance"
		 			1
		 		end
		 	end
		when "skillDown"
			array.sort!  do |a, b| 
		 		case 
		 		when a.skill==b.skill 
		 			0 
		 		when a.skill =="Beginner"
		 			1 
		 		when (a.skill =="Intermediate" and b.skill=="Advance")
		 			1
		 		when (a.skill=="Intermediate" and b.skill=="Beginner")
		 			-1
		 		when a.skill=="Advance"
		 			-1
		 		end
		 	end
		 		
		when "costUp"
			array.sort! { |x, y| x.cost <=> y.cost}
		when "costDown"
			array.sort! { |x, y| y.cost <=> x.cost}
		when "feedsUp"
			array.sort! { |x, y| x.feeds <=> y.feeds}
		when "feedsDown"
			array.sort! { |x, y| y.feeds <=> x.feeds}
		when "timeUp"
			array.sort! { |x, y| x.time <=> y.time}
		when "timeDown"
			array.sort! { |x, y| y.time <=> x.time}
		end

	end


end

