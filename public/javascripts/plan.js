var pin_plan = false;

function insert_locators() {
	jQuery('.locator a').each(function(i){
		locator = Raphael(this,50,50);
		img = locator.image("/images/icons/arrow_"+((+jQuery(this).attr('current'))?'over':'start')+".png",0,0,50,50);
		img.rotate(jQuery(this).attr('angle'),25,25);
		this.rimg = img;
	});  
}

function show_plan( plan ){
  // Turn off the previous plan
  $('.plan.current').removeClass('current');
  // Turn on the plan given the link's href
  plan.addClass('current');
  // Change view state
  $('.content').removeClass('image_content').addClass('plan_content');  
}

function hide_plan() {
  if( !pin_plan ){
    $('.content').removeClass('plan_content').addClass('image_content');
  }  
}

function init_plans() {
  insert_locators();

  // When the locators are mouseover'd, trigger the same event on the corresponding thumbnail
  $('body').delegate('.locator a', 'mouseover mouseout', function(e) {
    if( e.type == 'mouseover' ){
  		anchor = jQuery(this);
  		jQuery("#thumb_"+anchor.attr('locator')).find('img').trigger('mouseover');
  		if(!( +anchor.attr('current')) ) this.rimg.attr('src', '/images/icons/arrow_over.png' );      
    } else {
  		anchor = jQuery(this);
  		jQuery("#thumb_"+anchor.attr('locator')).find('img').trigger('mouseout');
  		if(!( +anchor.attr('current')) ) this.rimg.attr('src','/images/icons/arrow_start.png');
    }
  });
  
  // In case we're preloading, hide the plan on click
  $('body').delegate('.locator a', 'click', function(){ pin_plan = false; hide_plan() } );
  
  $('body').delegate('.plan_link', "mouseover mouseout", function(e){
    if (e.type == 'mouseover') {
      show_plan( $('#plan_'+$(e.target).attr('href').split('plans/')[1]) ); 
    } else {
      hide_plan();
    }
  });
  
  $('body').delegate('.plan_link', 'click', function(e){
    // Toggle state
    pin_plan = !pin_plan;
    
    e.preventDefault();
  })
}
