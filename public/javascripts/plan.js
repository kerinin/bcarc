jQuery(document).ready(init);

var currentView;

function init(){
	jQuery('.plan').hide();
	currentView = currentImage = jQuery('.image_container');
	
	jQuery('.locator a').each(function(i){
		locator = Raphael(this,50,50);
		img = locator.image("/images/icons/arrow_"+((+jQuery(this).attr('current'))?'over':'start')+".png",0,0,50,50);
		img.rotate(jQuery(this).attr('angle'),25,25);
		this.rimg = img;
		
		jQuery(this).hover(
			function(e){
				anchor = jQuery(this);
				jQuery("#thumb_"+anchor.attr('locator')).trigger('mouseenter');
				if(!( +anchor.attr('current')) ) this.rimg.attr('src', '/images/icons/arrow_over.png' );
			},function(e){
				anchor = jQuery(this);
				jQuery("#thumb_"+anchor.attr('locator')).trigger('mouseleave');
				if(!( +anchor.attr('current')) ) this.rimg.attr('src','/images/icons/arrow_start.png');
			}
		);
	});
		
	jQuery('.plan_link').each(function() {
		jQuery(this).hover(
			function(e){ 
				//show plan
				plan = jQuery('#plan_'+jQuery(e.target).attr('href').split('maps/')[1])
				
				if( currentView[0] != plan[0] ){
					currentImage.css('opacity',0);
					plan.show();
				}
				
			}, function(e){ 
				//hide plan
				plan = jQuery('#plan_'+jQuery(e.target).attr('href').split('maps/')[1])
				
				if( currentView[0] != plan[0] ){
					plan.hide();
					currentImage.css('opacity',1);
				}
			} 
		).click(function(e){
			plan = jQuery('#plan_'+jQuery(e.target).attr('href').split('maps/')[1]);
			
			currentView.find('.locator a:not(.current_locator)').addClass('other_locator');
			
			if( plan[0] == currentView[0] ){
				// re-clicking on plan - show image again
				
				//remove previous view
				plan.hide().removeClass('current_view');
				jQuery(e.target).removeClass('current_view');
				
				//prepare image
				currentImage.addClass('curent_view');
				currentView = currentImage;
				
				//show image
				currentImage.css('opacity',1);
				
			} else {
				// changing view to a plan
				
				//remove previous view
				currentImage.css('opacity',0);
				if( currentView[0] != currentImage[0] ){
					currentView.hide();
					jQuery('.plan_link').removeClass('current_view');
				}				
				
				//prepare new view
				plan.find('.locator a').removeClass('other_locator');
				plan.addClass('current_view');
				jQuery(e.target).addClass('current_view');
				currentView =plan;
				
				//show new view
				plan.show();
			}
			return false;
		});
		
	});
}
