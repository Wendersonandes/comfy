(function($){
	window.CMS || (window.CMS = {});

	window.CMS.load_events_from_facebook = function(){
		$('#getFacebookEvents').click(function(){
			$.ajax({
				type: 'GET',
				url: `${CMS.current_path}/get_facebook_events.json`,
				success: function(events){
					var events_template = HandlebarsTemplates['events'](events);
					$($.parseHTML(events_template)).hide().insertAfter('tr.table-head').fadeIn("slow");
				}
			})
		});
	}

	return window.CMS.save_event_from_facebook = function(){
		$(document).on("click", ".save_event_from_facebook", function(){
			var lead = $(this).closest('tr');
			var data = $(lead).data('event')
			var event = {
				title: data.name,
				description: data.description,
				start: data.start_time,
				end_time: data.end_time,
				facebook_id: data.id,
			}
			$.ajax({
				type: 'POST',
				url: CMS.current_path,
				data: {event: event},
				success: function(data){
					console.log(data);
				}
			});
		});
	}
})(jQuery);
