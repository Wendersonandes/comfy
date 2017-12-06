(function($){
	window.CMS || (window.CMS = {});

	window.CMS.recover_image = function(){
		$(".recover-image").click(function() {
			var self = this;
			var image_id = $(this).data("id");
			$.ajax({
				type: "POST",
				url: `${CMS.image_path}/${image_id}/recover`,
				success: function(){
					$(self).closest( "div.thumbnail" ).hide('slow')
					console.log( image_id );
				}
			});
		});
	}

	return window.CMS.trash_image = function(){
		$( ".trash-image" ).click(function() {
			var self = this;
			var image_id = $(this).data("id");
			$.ajax({
				type: "POST",
				url: `${CMS.gallery_images_path}/${image_id}/trash`,
				success: function(){
					$(self).closest( "div.thumbnail" ).hide('slow')
					console.log( image_id );
				}
			});
		});
	}
})(jQuery);
