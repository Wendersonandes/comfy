(function($){
	window.CMS || (window.CMS = {});
	return window.CMS.sortable_grid = function(){
		var el = document.getElementById("sortable_gallery");
		if (typeof(el) != 'undefined' && el != null){
			Sortable.create(el, {
				animation: 150,
				handle: '.dragger',
				onEnd: function(){
					updated_order = this.toArray()
					// send the updated order via ajax
					$.ajax({
						type: "PUT",
						url: CMS.gallery_images_reorder_path,
						data: { comfy_cms_image: updated_order }
					});
				}
			});
		}
	}
})(jQuery);
