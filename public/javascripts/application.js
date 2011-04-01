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
			alert(ui.draggable.attr("data-idea"));
			alert(ui.draggable.attr("data-item"));
		}
	});
});
