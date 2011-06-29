// List of HTML content for insertion, indexed by URL
var content_list = {};
var DOM_state = null;
var transition_state = null;

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
      $('.spinner.current').wrap("<div class='content swap_target'>");      
    }
    DOM_state = path;
  }
}

function prepare_for_transition( name ) {
  if( name == 'from_right' && transition_state != name ) { 
    //$('.slide_window').css({'left':0,'right':null});
    
    // Wrap anything that isn't already wrapped
    $('.slide_window > .content').wrap( "<div class='slide_box' style='position:relative;left:0px;top:0px;'>" );
    
    // Make a new swap target
    $('.content').removeClass('swap_target');
    $('.slide_window').append( $("<div class='content swap_target''></div>") );
    
    // Wrap the new swap target, and start it offscreen
    $('.content.swap_target').wrap( "<div class='slide_box' style='position:absolute;left:800px;top:0px;'>" );
    
  } else if( name == 'from_left' && transition_state != name ) {
    //$('.slide_window').css({'left':null, 'right':0});
    
    $('.slide_window > .content').wrap( "<div class='slide_box' style='position:relative;right:0px;top:0px;'>" );
    
    $('.content').removeClass('swap_target');
    $('.slide_window').append( $("<div class='content swap_target'></div>") );
    
    $('.content.swap_target').wrap( "<div class='slide_box' style='position:absolute;right:800px;top:0px;'>" )
  }
  transition_state = name;
}

function animation_callback() {
  // Remove content that isn't the current view
  $('.content').not('.swap_target').parent().remove();
  // Reset the slide box's CSS
  $('.slide_box').attr('style', 'position:relative;left:0px;top:0px;');
  
  transition_state = null;  
}

function animation_for( transition ) {
  if( transition == 'from_right' ) {
    $('.slide_window > *').animate({'left': '-=800'}, 1000, 'swing', animation_callback);      
  } else if( transition == 'from_left' ) {
    $('.slide_window > *').animate({'right' : '-=800'}, 1000, 'swing', animation_callback);
  }
}

function init() {
  
  var History = window.History;
  
  // Behavior when URL is changed
  $(window).bind('statechange',function(e){
    var State = History.getState();
    var path = State.url;
    
    // Event triggers multiple times for some reason
    if( DOM_state != path ){

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
    
      animation_for( transition );
    }
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