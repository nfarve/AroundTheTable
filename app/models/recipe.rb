class Recipe < ActiveRecord::Base
	has_many :ingredients
	has_many :steps
	accepts_nested_attributes_for :ingredients, :allow_destroy => true
	accepts_nested_attributes_for :steps, :allow_destroy => true
	validates :name, presence: true
end
