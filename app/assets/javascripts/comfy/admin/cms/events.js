(function($){
	window.CMS || (window.CMS = {});

	window.CMS.quick_edit_event = function(){
		$(document).on('click', '.tr-event-body', function(){
			var event_data = $(this).data('event');
			var event_edit_template = HandlebarsTemplates['events/edit'](event_data);
			$('#updateContainer').html($.parseHTML(event_edit_template)).hide().fadeIn("slow");
		});
	}

	window.CMS.quick_update_event = function(){
		$(document).on('submit', 'form#quick_event_edit', function(e){
			e.preventDefault();
			var formData = new FormData(this);
			$.ajax({
				url: `${CMS.current_site_path}/events/${formData.get('event[id]')}`,
				type: 'PUT',
				data: formData,
				processData: false,
				contentType: false,
				success: function(data){
					console.log(data.title)
				}
			})
		});
	}

	window.CMS.load_events_from_facebook = function(){
		$('#getFacebookEvents').click(function(){
			$.ajax({
				type: 'GET',
				url: `${CMS.current_path}/get_facebook_events.json`,
				success: function(events){
					var events_template = HandlebarsTemplates['events/index'](events);
					$('table.table.table-hover').html($.parseHTML(events_template)).hide().fadeIn("slow");
				}
			})
		});
	}

	window.CMS.quick_edit_facebook_event = function(){
		$(document).on('click', '.tr-facebook-event-body', function(){
			var event_data = $(this).data('event');
			var event_edit_template = HandlebarsTemplates['events/quick_save'](event_data);
			$('#updateContainer').html($.parseHTML(event_edit_template)).hide().fadeIn("slow");
		});
	}

	return window.CMS.save_event_from_facebook = function(){
		$(document).on("submit", "form#quick_save_event", function(e){
			e.preventDefault();
			var formData = new FormData(this);
			var table_row = document.getElementById(formData.get('event[facebook_id]'));
			$.ajax({
				type: 'POST',
				url: CMS.current_path,
				data: formData,
				processData: false,
				contentType: false,
				success: function(data){
					$(table_row).hide();
					console.log(formData.get('event[title]'));
				}
			});
		});
	}
})(jQuery);
