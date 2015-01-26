# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/





@formChange = (check) ->
	console.log(check.checked);
	if check.checked==true
		$('#optionsa').show();
		$('#optionsb').hide();
	else
		$('#optionsb').show();
		$('#optionsa').hide();



@textFieldAdjust= (el) ->
	length = $(el).val().length;
	console.log(length);
	if length > 60
        if (length % 60) == 0
        	rows = $(el).attr('rows');

        	rows++;
        	console.log(rows);
        	$(el).attr('rows', rows);
        
	
	

@folder_lookup  = (which) ->
	
	switch(which.value)
		when "Main"
			###
			$("#ingredients_holder").append($("#main_filler").html());
			$('[name=which]').val(0);
			
			$("#new_recipe").trigger("submit.Main");	
			###
			
			$('input[name="Main"]').click();
			console.log("main selected")
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

@resetCount= ->
	count = 0

@ready = ->
	if $('.recipes').length==0
		$("#prev").attr("disabled", true)
		$("#next").attr("disabled", true)
	else
		count = parseInt($(".recipes").first().attr('id').split('_')[1]);
		if $('#recipe_'+String(count-1)).length==0
			$("#prev").attr("disabled", true)


@moveUp = ->
	console.log(count)
	if $('#recipe_'+String(count+1)).length
		$('#recipe_'+String(count+1)).show();
		$('#recipe_'+String(count)).hide();	
		$("#message").hide();
		count+=1;
	else
		$("#message").show();
		$("#next").attr("disabled", true)

	if $('#recipe_'+String(count-1)).length
		$("#prev").prop('disabled',false);
	else
		$("#prev").attr("disabled", true)

	if $('#recipe_'+String(count+1)).length
		$("#next").prop('disabled',false);
	else
		$("#next").attr("disabled", true)
		

@moveDown = ->
	console.log(count)
	if $('#recipe_'+String(count-1)).length
		$('#recipe_'+String(count-1)).show();
		$('#recipe_'+String(count)).hide();	
		count-=1;
	else
		$("#message").show();
		$("#prev").attr("disabled", true)

	if $('#recipe_'+String(count+1)).length
		$("#next").prop('disabled',false);
	else
		$("#next").attr("disabled", true)


	if $('#recipe_'+String(count-1)).length
		$("#prev").prop('disabled',false);
	else
		$("#prev").attr("disabled", true)

	
	
	
	
