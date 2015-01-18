# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@folder_lookup  = (which) ->
	
	switch(which.value)
		when "Main"
			###
			$("#ingredients_holder").prepend($("#main_filler").html());
			$('[name=which]').val(0);
			###
			$('input[name="Main"]').click();
		when "Veg"
			$('input[name="Veg"]').click();
		when "Spice"
			$('input[name="Spice"]').click();
		when "Misc"
			$('input[name="Misc"]').click();
	return which.value

@addIngredient = ->
	$("#tester").append($("#category2").html());


