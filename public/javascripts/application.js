$(document).ready(function() 
{
	$('.idea_item .edit_box').hide();
	
	$('.idea_item').hover(function() {
		//$(this).find('.edit_box').show();
	}, function() {
		$(this).find('.edit_box').hide();
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
	
	/*	Toggle idea private / public
	________________________________________________________ */
	
	function addToggleEvent()
	{
		$('.access_box:not(.active) > a').click(function() 
		{
			 sendAndToggle();	
			 return false;
		});
	}
	
	function sendAndToggle()
	{
		 	var idea_id = $("#access_control").attr('data-idea-id');
					
			$.ajax({
				url: "/ideas/" + idea_id + "/toggle_access",
				type: "POST",
			  success: function(data){
					
					var active = $('#access' + data);
					active.html(active.find("a").html());
					active.addClass("active");
					
					var deactive = $('#access' + (data == "0" ? "1" : "0" ));
					deactive.removeClass("active");
					deactive.html('<a href="#">' + deactive.html() + '</a>');
					
					addToggleEvent();
					
			  },
				error:function (xhr, ajaxOptions, thrownError){
					alert(thrownError);
				}
			});
	}
	
	addToggleEvent();
	
});
