jQuery(document).ready(init);

function navOver(e) {

	jQuery( "#"+jQuery( jQuery(e.target).parents('[nav]') ).attr('nav') ).children().hide();
	jQuery('#'+jQuery(e.target).parent().attr('section') ).show();
	
	jQuery(e.target).parents('[nav]').children().removeClass('currentNav');
	jQuery(e.target).parent().addClass('currentNav');
}

function init(){
	jQuery("[nav]").each( function () {
		
		jQuery(this).children("[section]").mouseover( navOver );
		
		jQuery( "#"+jQuery(this).attr('nav') ).children().hide();
		
		jQuery("[rel=startnav]").trigger('mouseover');
		
	} );
}
