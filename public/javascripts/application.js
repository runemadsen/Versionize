function add_formfield(divname, content)
{
	$(divname).append(content);
	return false;
}

$(document).ready(function() 
{
	$('.idea_item .edit_item').hide();
	
	$('.idea_item').hover(function() {
		$(this).find('.edit_item').show();
	}, function() {
		$(this).find('.edit_item').hide();
	});
	
	$(".drag_item").draggable({  
		revert: true,
		revertDuration: 0
	});
	
	$("#drop_box").droppable({
		drop: function(event, ui) {
			
			var idea_id = ui.draggable.attr("data-idea");
			var item_id = ui.draggable.attr("data-item");
			var item_type = ui.draggable.attr("data-item-type");
			var show_text = ui.draggable.parent().parent().text().substr(0, 30) + "...";
			
			if(item_type == "image") show_text = "Image";
			
			$(this).append('<div class="drop_box_item">' + show_text + "</div>");
			
			if($(this).find('#placeholder'))
			{
				$(this).find('#placeholder').hide();
			}
		}
	});
	
	// word count on description
	$("#description_field").counter({
	    goal: 500,
	    insert: '#countdown'
	});
	
	$('.tip_field').focus(function() {
		$(".tip_highlight").removeClass("tip_highlight");
	  var tip_id = $(this).attr('data-tip-id');
		var div = $("#" + tip_id);
		div.addClass("tip_highlight");
	});
	
	$('.tip_field').focusout(function() {
		$(".tip_highlight").removeClass("tip_highlight");
	});
	
});
