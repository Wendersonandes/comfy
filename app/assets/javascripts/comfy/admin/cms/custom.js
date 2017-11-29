(function($){
	window.CMS || (window.CMS = {});
	return window.CMS.sortable_grid = function(){
		$('.sortable-grid').sortable({
			handle: 'div.dragger',
			placeholder: 'ma1 h4 w4 fl thumbnail ba b--dashed bw1 b--green',
			axis:   'x',
			opacity: 0.5,
			start: function(e, ui){
				$(ui.placeholder).hide(300);
			},
			change: function (e,ui){
				$(ui.placeholder).hide().show(300);
			},
			update: function(){
				return $.post(`${CMS.galleries_path}/${$(this).data('gallery-id')}/images/reorder`, `_method=put&${$(this).sortable('serialize')}`);
			} 
		});
	}
})(jQuery);
