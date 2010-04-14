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

function testf(e){
	alert(e);
}

jQuery(window).bind('load', function init() {
	jQuery("img[fadeover]").each(function() {
		initCrossFade(this,this.getAttribute('fadeover') ) 
	} );
	
	jQuery("img[swapover]").each(function() {
		preload = new Image();
		preload.src = this.getAttribute('swapover');
		
		jQuery(this).hover(swapOver,swapOut);	
	} );
} );

