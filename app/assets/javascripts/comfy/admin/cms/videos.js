(function($){
	window.CMS || (window.CMS = {});

	window.CMS.load_videos_from_youtube = function(){
		$('#videosFromYoutube').click(function(){
			$.ajax({
				type: 'GET',
				url: `${CMS.current_path}/get_videos_from_youtube.json`,
				success: function(videos){
					var videos_template = HandlebarsTemplates['videos/index'](videos);
					$('table.table.table-hover').html($.parseHTML(videos_template)).hide().fadeIn("slow");
				}
			})
		});
	}

	window.CMS.quick_edit_video = function(){
		$(document).on('click', '.tr-video-body', function(){
			var video_data = $(this).data('video');
			var video_edit_template = HandlebarsTemplates['videos/quick_save'](video_data);
			$('#updateContainer').html($.parseHTML(video_edit_template)).hide().fadeIn("slow");
			var videoUrl = `https://www.youtube.com/watch?v=${video_data.youtube_id}`
			var options = { fluid: true, 
											techOrder: ["youtube"], 
											sources: [{ type: "video/youtube", 
																	src: videoUrl }], 
											youtube: { iv_load_policy: 1 } 
										};
			var player = document.getElementById("videoarea");
			videojs(player, options);
		});
	}

	window.CMS.quick_update_video = function(){
		$(document).on('submit', 'form#quick_update_video', function(e){
			e.preventDefault();
			var formData = new FormData(this);
			$.ajax({
				url: `${CMS.current_site_path}/videos/${formData.get('event[id]')}`,
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


	return window.CMS.quick_save_video = function(){
		$(document).on('submit', 'form#quick_save_video', function(e){
			e.preventDefault();
			var formData = new FormData(this);
			$.ajax({
				url: CMS.current_path,
				type: 'POST',
				data: formData,
				processData: false,
				contentType: false,
				success: function(data){
					console.log(data.title)
				}
			})
		});
	}

})(jQuery);
