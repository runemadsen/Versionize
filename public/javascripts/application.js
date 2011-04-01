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
			var t = ui.draggable.attr("data-item-type");
			
			if($(this).find('#placeholder'))
			{
				$(this).find('#placeholder').hide();
			}
			
			//alert(ui.draggable.attr("data-idea"));
			//alert(ui.draggable.attr("data-item"));
			
			$(this).append('<div class="drop_box_item">' + t + "</div>");
			
			// insert something into form
		}
	});
});
