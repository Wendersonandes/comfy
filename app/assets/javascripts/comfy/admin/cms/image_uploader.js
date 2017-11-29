(function($){
	window.CMS || (window.CMS = {});
	return window.CMS.image_uploader = function(){
		$('.image_uploader[type=file]').fileupload({
			add: function(e, data) {
				data.progressBar = $('<div class="progress w-100"><div class="progress-bar"></div></div>').prependTo('.sortable-grid');
				var options = {
					extension: data.files[0].name.match(/(\.\w+)?$/)[0], // set extension
					_: Date.now(),                                       // prevent caching
				}

				$.getJSON(`${CMS.image_upload_endpoint_path}/cache/presign`, options, function(result) {
					data.formData = result['fields'];
					data.url = result['url'];
					data.submit();
				});
			},

			progress: function(e, data) {
				var progress = parseInt(data.loaded / data.total * 100, 10);
				var percentage = progress.toString() + '%'
				data.progressBar.find(".progress-bar").css("width", percentage).html(percentage);
			},

			done: function(e, data) {
				data.progressBar.remove();
				var image = {
					id: /cache\/(.+)/.exec(data.formData.key)[1], // we have to remove the prefix part
					storage: 'cache',
					metadata: {
						size:      data.files[0].size,
						filename:  data.files[0].name,
						mime_type: data.files[0].type
					}
				}

				$.ajax(CMS.gallery_images_path, {
					method: 'POST', 
					data: {
						image: { file: JSON.stringify(image)}
					},
					success: function(image){
						var image_template = HandlebarsTemplates['image'](image);
						$(image_template).hide().prependTo('.sortable-grid').fadeIn("slow");
						CMS.sortable_grid();
					}
				})
			}
		});

	}
})(jQuery);
