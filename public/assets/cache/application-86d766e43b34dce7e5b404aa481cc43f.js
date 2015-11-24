// array( search, replace )
replaceRules = new Array( '_start', '_over' );

function swapOver(e){
	if (over = e.target.getAttribute('swapover') ) {
		e.target.setAttribute('swapOut',e.target.src);
		e.target.src = over;
	} else {
		e.src.src = e.src.src.replace( eval('/'+ replaceRules[0]+'/'), replaceRules[1] );
	}
}

function swapOut(e){
	if (out = e.target.getAttribute('swapout') ) {
		e.target.src = out;
	} else {
		e.src.src = e.src.src.replace( eval('/'+ replaceRules[1]+'/'), replaceRules[0] );
	}
}

function fadeOver(e){
	if(e.target.effect_handle){
		e.target.effect_handle.cancel();
	}
	e.target.setOpacity(0);
}

function fadeOut(e){
	e.target.effect_handle = new Effect.Opacity(e.target, { to: 1, duration: 0.5 });
}

function initCrossFade(start,over_uri){
	//NOTE: this is a hack to avoid a rounding error in Firefox
	// it recreates the original image and positions it absolutely so both the mousover and mouseout images are absolutized
	//insert mouseover image and absolutize
	start_positioned = Element.insert(start, {after:'<img src="#" />'} ).next();
	over = Element.insert(start_positioned, {after:'<img src="#" />'} ).next();
	Element.absolutize(start_positioned);
	Element.absolutize(over);
	start_positioned.setStyle({height:start.getStyle('height'),width:start.getStyle('width')});
	over.setStyle({height:start.getStyle('height'),width:start.getStyle('width')});
	Element.clonePosition(start_positioned,start,{setWidth:false,setHeight:false});
	Element.clonePosition(over,start,{setWidth:false,setHeight:false});
	
	//set display and src
	Element.setStyle( start,'opacity:0;' );
	Element.setStyle( start,'z-index:1;' );
	Element.setStyle( start_positioned,'z-index:3;' );
	Element.setStyle( over,'z-index:2;' );
	start_positioned.src = start.src;
	over.src = over_uri;
		
	//attach behavior
	jQuery(over).bind('load',[start_positioned,start],function(e) {
		jQuery(e.data[0]).bind('mouseover',e.data[1], fadeOver).bind('mouseout',e.data[1], fadeOut);
	} );
	
}



var planCurrentView;

function init_plans(){
	jQuery('.plan').hide();
	planCurrentView = currentImage = jQuery('.image_container');
	
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
				
				if( planCurrentView[0] != plan[0] ){
					currentImage.css('opacity',0);
					plan.show();
				}
				
			}, function(e){ 
				//hide plan
				plan = jQuery('#plan_'+jQuery(e.target).attr('href').split('maps/')[1])
				
				if( planCurrentView[0] != plan[0] ){
					plan.hide();
					currentImage.css('opacity',1);
				}
			} 
		).click(function(e){
			plan = jQuery('#plan_'+jQuery(e.target).attr('href').split('maps/')[1]);
			
			planCurrentView.find('.locator a:not(.current_locator)').addClass('other_locator');
			
			if( plan[0] == planCurrentView[0] ){
				// re-clicking on plan - show image again
				
				//remove previous view
				plan.hide().removeClass('current_view');
				jQuery(e.target).removeClass('current_view');
				
				//prepare image
				currentImage.addClass('curent_view');
				planCurrentView = currentImage;
				
				//show image
				currentImage.css('opacity',1);
				
			} else {
				// changing view to a plan
				
				//remove previous view
				currentImage.css('opacity',0);
				if( planCurrentView[0] != currentImage[0] ){
					planCurrentView.hide();
					jQuery('.plan_link').removeClass('current_view');
				}				
				
				//prepare new view
				plan.find('.locator a').removeClass('other_locator');
				plan.addClass('current_view');
				jQuery(e.target).addClass('current_view');
				planCurrentView =plan;
				
				//show new view
				plan.show();
			}
			return false;
		});
		
	});
}


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
;
