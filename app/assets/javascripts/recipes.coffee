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


count=0;

@ready = ->
	count = parseInt($(".recipes").first().attr('id').split('_')[1]);
	if $('#recipe_'+String(count-1)).length==0
		$("#prev").attr("disabled", true)


@moveUp = ->
	if $('#recipe_'+String(count+1)).length
		$('#recipe_'+String(count+1)).show();
		$('#recipe_'+String(count)).hide();	
		$("#message").hide();
	else
		$("#message").show();
		$("#next").attr("disabled", true)

	if $('#recipe_'+String(count)).length
		console.log(count);
		$("#prev").prop('disabled',false);
	else
		$("#prev").attr("disabled", true)
	count+=1;	

@moveDown = ->
	if count==5
		count-=1;
	console.log(count);
	if $('#recipe_'+String(count-1)).length
		$('#recipe_'+String(count-1)).show();
		$('#recipe_'+String(count)).hide();	
	else
		$("#message").show();
		$("#prev").attr("disabled", true)

	if $('#recipe_'+String(count)).length
		$("#next").prop('disabled',false);
	else
		$("#next").attr("disabled", true)
	count-=1;
	
	
	
