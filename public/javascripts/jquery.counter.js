(function($) {
    $.fn.extend({
        counter: function(options) 
				{
            var defaults = {
                goal: 140,
                insert: "#countdown"
            };

            var options = $.extend({}, defaults, options);
            var flag = false; 

            return this.each(function() 
						{   
            	var $obj = $(this);
    					var target = $(options.insert);

              target.append('<span id=\"' + this.id + '_counter\">' + (options.goal - $($obj).val().length) + '</span>');
  
              var $currentCount = $("#" + this.id + "_counter");

              $obj.bind('keyup click blur focus change paste', function(new_length) 
							{
              	new_length = $($obj).val().length;
              

              	if (options.goal - new_length <= 0) 
								{
              	 	$(this).val($(this).val().substring(0, options.goal));
              	 	flag = true;
              	}
                                
              	$obj.keydown(function(event) 
								{
              		if (flag) 
									{
									 	this.focus();
                            
                   	if ((event.keyCode !== 46 && event.keyCode !== 8)) 
									 	{
											if ($(this).val().length > options.goal) 
											{
                      	$(this).val($(this).val().substring(0, options.goal));
                      	return false;   
									 		} 
									 
                 		}
 									}
									else 
									{
                		flag = false;
										return true;
                	}
              	}); 
              
								$currentCount.text(options.goal - new_length);
             	});
            }); 
        	} 
    	}); 
})
(jQuery);