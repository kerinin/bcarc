// List of HTML content for insertion, indexed by URL
var content_list = {};
var DOM_state = null;

function cache_path(path) {
  if( !content_list[path] ){
    // Request the path, when it get back make sure the UI is updated (possible that it'll be requested during the page load)
    $.getScript(path, insert_content);
    content_list[path] = 'caching';
  }
}

function cache_images( scope ) {
  // Cache the next 4 images
  $('a.current_image').nextAll('a[rel=prerender]:lt(4)').each( function(i,elem) {
    cache_path( $(elem).attr('href') );
  });  
  // And cache the first 2 images
  $('a[rel=prerender]:lt(2)').each( function(e,elem) {
    cache_path( $(elem).attr('href') );  
  });
}

function insert_content() {
  var State = History.getState();
  var path = State.url;
  
  if( path != DOM_state ) {
    if( content = content_list[path] ) {
      for( var selector in content ) {
        $(selector).replaceWith( content[selector].clone() );
      }
    } else {
      $('.content.swap_target').replaceWith( $('.spinner.hidden').clone().removeClass('hidden').addClass('current') );
      $('.spinner.current').wrap("<div class='content'>");      
    }
    DOM_state = path;
  }
}

function prepare_for_transition( name ) {
  if( name == 'from_right' ) { 
    $('.content').removeClass('swap_target');
    $('.slide_box').css({'left':0,'right':null}).append( $("<div class='content swap_target' style='position:absolute;left:800px;top:0px;'></div>") )
  } else if( name == 'from_left' ) {
    $('.content').removeClass('swap_target');
    $('.slide_box').css({'left':null, 'right':0}).append( $("<div class='content swap_target' style='position:absolute;right:800px;top:0px;'></div>"))
  }
}

function animation_for( transition ) {
  if( transition == 'from_right' ) {
    $('.slide_box > *').animate({'left': '-=800'}, 1000, 'swing', function(){
      $('.content').not('.swap_target').remove();
      $('.content').removeAttr("style");
    });      
  } else if( transition == 'from_left' ) {
    $('.slide_box > *').animate({'right' : '-=800'}, 1000, 'swing', function(){
      $('.content').not('.swap_target').remove();
      $('.content').removeAttr("style");
    });
  }
}

function init() {
  
  var History = window.History;
  
  // Behavior when URL is changed
  $(window).bind('statechange',function(e){
    var State = History.getState();
    var path = State.url;
    var transition = null;
    if( path == $('#next_button a[rel=prerender]').attr('href') ) { 
      transition = 'from_right';
    } else if( path == $('#prev_button a[rel=prerender]').attr('href') ) {
      transition = 'from_left';
    }    
    
    prepare_for_transition( transition );
    
    /*
    Inserting the content clears out the style attributes that are being animate, short circuiting the
    whole animation.  Probably need to dynamically wrap the content in an animation container and then
    unwrap it (and delete the old content) when the transition is over.
    */
    insert_content();
    
    //animation_for( transition );
  });
  
  // State change triggers
  $('body').delegate('a[rel=prerender]', 'click', function(e) {
    History.pushState(null, null, $(this).attr('href') );
    e.preventDefault();
  })
  
  cache_images();  
}

$(document).ready( function() {
  // Cache the current page
  DOM_state = window.location.href;
  content_list[window.location.href] = {
    ".project_header.thumb_container" : $(".project_header.thumb_container").clone(),
    ".content" : $(".content").clone()
  }
  
  // This keeps the browser spinner from going while the ajax loads
  // May also avoid some page loads if people click back quickly
  var t=setTimeout(init,1500);
  
  // Put the footer inside the content
  $('.content').addClass('swap_target').append( $('.footer') );
});