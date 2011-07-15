var content_list = [];

function cache_path(path) {
  if( !content_list[path] ){
    // Request the path, when it get back make sure the UI is updated (possible that it'll be requested during the page load)
    $.getScript(path);
    content_list[path] = 'caching';
  }
}

function cache_content( scope ) {
  // Cache the next 4 pages
  $('a.current_image').nextAll('a[rel=prerender]:lt(1)').each( function(i,elem) {
    cache_path( $(elem).attr('href') );
  });  
  // And cache the first 2 images
  //$('a[rel=prerender]:lt(2)').each( function(e,elem) {
  //  cache_path( $(elem).attr('href') );  
  //});
}

function animation_callback() {
  var State = History.getState();
  var path = State.url;
  
  if( $(this).find('.content').is('[id="'+path+'"]') ) {
    // Remove non-active panes from the flow
    $('.slide_box').css('position', 'absolute');

    // And insert the current one (controls overflow on the slide window)
    $('.content[id="'+path+'"]').closest('.slide_box').css('position', 'relative');  
  }
}

function transition_for( transition, target ) {
  switch( transition ) {
  case 'slide':
    $('.slide_bar').stop().animate({'left': -get_offset(target)}, 1000, 'swing', animation_callback);
    break;
  case 'swap':
    $('.slide_bar').stop().animate({'left': -get_offset(target)}, 0, 'swing', animation_callback);
    break;
  }
}

function update_nav(current_path) {
  $('.thumb_container > a.current_image').removeClass('current_image');
  $('.thumb_container > a[href="'+current_path+'"]').addClass('current_image');
  
  var prev = $('.thumb_container a.current_image').prev('a');
  if( prev.is('[rel=prerender]') ){
    $('#prev_button a').attr('href', prev.attr('href') ).show();
  } else if( prev.is() ) {
    $('#prev_button a').attr( {'href': next.attr('href'),'rel': null } ).show();
  } else {
    $('#prev_button a').hide();
  }
  
  var next = $('.thumb_container a.current_image').next('a');
  if( next.is('[rel=prerender]') ){
    $('#next_button a').attr('href', next.attr('href') ).show();
  } else if( next.is() ) {
    $('#next_button a').attr( {'href': next.attr('href'),'rel': null } ).show();
  } else {
    $('#next_button a').hide();
  }
}

function get_offset(url) {
  return $('.content[id="'+url+'"]').position()['left'];
}

$(document).ready( function() {
  
  // Cache the current content
  var content = $('.container > .content').wrap('<div class="slide_window"><div class="slide_bar" style="position: relative; left: 0; top: 0;">').detach();
  content[window.location.href] = 'loaded';
  
  // Construct the slider pane
  $('.thumb_container > a[rel=prerender]').each( function() {
    // Determine the image index
    var index = $(this).index('.thumb_container > a[rel=prerender]') - $('.thumb_container > a.current_image').index('.thumb_container > a[rel=prerender]');
    var href = $(this).attr('href');
    var current = (href == window.location.href);
    var pos = ( current ? 'relative' : 'absolute' );
    
    if( ( $('.content[id="'+href+'"]').length == 0 ) && current ) {
      // Insert the cached content
      content.attr('id', href).css({position: pos, left: (index * 800)+'px', top: 0});
      $('.slide_bar').append( content );
    } else if( $('.content[id="'+href+'"]').length == 0 ) {
      // Add a spinner for the image
      $('.slide_bar').append( $('.spinner.hidden').clone().removeClass('hidden') );

      // Wrap the added spinner
      $('.slide_bar > .spinner').wrap( '<div class="content" id="'+$(this).attr('href')+'">' );      
      
      // Position the added spinner
      $('.content[id="'+href+'"]').css({position: pos, left: (index * 800)+'px', top: 0});
    }
  });
    
  // Init History
  var History = window.History;
  $(window).bind('statechange',function(e){
    var State = History.getState();
    var path = State.url;
    
    var transition = null;
    if( path == $('.thumb_container a.current_image').attr('href') ) {
      // Do nothing
    } else if( path == $('#next_button a[rel=prerender]').attr('href') || path == $('#prev_button a[rel=prerender]').attr('href') ) {
      transition = 'slide';
    } else {
      transition = 'swap';
    }

    update_nav(path);

    transition_for( transition, path );
    
    // Make sure the current path has been requested
    cache_path(path);     
    
    // Request the next couple bits
    cache_content();
  });
  
  // Init Behavior
  $('body').delegate('a[rel=prerender]', 'click', function(e) {
    var State = History.getState();
    var path = State.url;
    
    if( path != $(this).attr('href') ) {
      History.pushState(null, null, $(this).attr('href') );
    }
    
    e.preventDefault();
    e.stopImmediatePropagation();
  })
  
  cache_content();
} );

/*
// List of HTML content for insertion, indexed by URL
var content_list = {};
var DOM_state = null;
var transition_state = null;

function cache_path(path) {
  if( !content_list[path] ){
    // Request the path, when it get back make sure the UI is updated (possible that it'll be requested during the page load)
    $.getScript(path);
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
    content = content_list[path];
    if( content && content != 'caching' ) {
      for( var selector in content ) {
        $(selector).replaceWith( content[selector].clone() );
      }
      DOM_state = path;
    } else {
      $('.content.swap_target').replaceWith( $('.spinner.hidden').clone().removeClass('hidden').addClass('current') );
      $('.spinner.current').wrap("<div class='content swap_target'>");      
      cache_path(path);
    }
  }
}

function prepare_for_transition( name ) {
  if( name && transition_state != name ) {
    // Wrap anything that isn't already wrapped
    $('.slide_window > .content').wrap( "<div class='slide_box' style='position: relative; left: 0px; top: 0px;'>" );
    
    // Make a new swap target
    $('.content').removeClass('swap_target');
    $('.slide_window').append( $("<div class='content swap_target''></div>") );    
    
    // Wrap the new swap target, and start it offscreen
    if( name == 'from_right' ) { 
      $('.content.swap_target').wrap( "<div class='slide_box' style='position: absolute; left: 800px; top: 0px;'>" );
    } else if( name == 'from_left' ) {
      $('.content.swap_target').wrap( "<div class='slide_box' style='position: absolute; left: -800px; top: 0px;'>" );
    }
    transition_state = name;    
  }
}

function animation_callback() {
  // Remove content that isn't the current view
  $('.content').not('.swap_target').parent().remove();
  $('.slide_box:empty').remove();
  // Reset the slide box's CSS
  $('.slide_box').attr('style', 'position: relative; left: 0px; top: 0px;');
  
  transition_state = null;  
}

function animation_for( transition ) {
  if( transition == 'from_right' ) {
    $('.slide_window > *').animate({'left': '-=800'}, 1000, 'swing', animation_callback);      
  } else if( transition == 'from_left' ) {
    $('.slide_window > *').animate({'left' : '+=800'}, 1000, 'swing', animation_callback);
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
  // Put the footer inside the content
  $('.content').addClass('swap_target').append( $('.footer') );
  
  // Cache the current page
  DOM_state = window.location.href;
  content_list[window.location.href] = {
    ".project_header.thumb_container" : $(".project_header.thumb_container").clone(),
    ".content" : $(".content").clone()
  }
  
  // This keeps the browser spinner from going while the ajax loads
  // May also avoid some page loads if people click back quickly
  var t=setTimeout(init,1500);
  

});
*/