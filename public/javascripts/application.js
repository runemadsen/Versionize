function add_formfield(divname, content)
{
	$(divname).append(content);
	return false;
}

$(document).ready(function() 
{
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
			
			// insert something into form
		}
	});
});
