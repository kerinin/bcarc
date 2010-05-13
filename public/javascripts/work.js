function hideWorkText(e){
	var container = jQuery(e.target).parents('.work_container')
	container.children('.work_thumb').fadeTo(200,1);
	container.children('a.work_text').unbind('mouseleave').hide();
}

function showWorkText(e){
	jQuery("a.work_text").hide();
	var container = jQuery(e.target).parents('.work_container');
	container.children('.work_thumb').fadeTo(0,.15);
	container.children('a.work_text').show().mouseleave(hideWorkText);
}
