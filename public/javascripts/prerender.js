// List of HTML content for insertion, indexed by URL
var content_list = {}
var current_DOM_path = null

// Load content from a given path
function load_path( path ) {
  if( content = content_list[path] ){
    // If the path has changed, and the content has downloaded (IE, we're not still waiting for it)
    // The AJAX request triggers a DOM refresh, so we can terminate if it's caching - when it arrives
    // the callback should take care of the UI.
    if( path != current_DOM_path && content != 'caching' ) {
      // Update the DOM
      for( var selector in content ) {
        $(selector).replaceWith( content[selector].clone() );
      }
      // And keep track of what we're looking at currently
      current_DOM_path = path;
    }
  // If the path hasn't been requested, call an ajax request for it
  } else {
    cache_path(path)
  }
}

function cache_path(path) {
  if( !content_list[path] ){
    // Request the path, when it get back make sure the UI is updated (possible that it'll be requested during the page load)
    $.getScript(path, refresh_DOM);
    content_list[path] = 'caching';
  }
}

function refresh_DOM() {
  load_path(window.location.pathname);
  cache_images();
}

function cache_images( scope ) {
  // Cache the next 2 images
  $('a.current_image').nextAll('a[rel=prerender]:lt(4)').each( function(i,elem) {
    cache_path( $(elem).attr('href') );
  });  
  // And cache the first 2 images
  $('a[rel=prerender]:lt(2)').each( function(e,elem) {
    cache_path( $(elem).attr('href') );  
  });
}

$(document).ready( function() {
  $.htmlhistory.init({ interceptLinks: false });
  
  $('body').delegate('a[rel=prerender]', 'click', function(e) {
    $.htmlhistory.changeTo( $(this).attr('href') );
    e.preventDefault();
  })
  
  $(window).bind('htmlhistory', function(e) {
    load_path( window.location.pathname);
  });
  
  // Cache the current page
  current_DOM_path = window.location.pathname;
  content_list[window.location.pathname] = {
    ".project_header.thumb_container" : $(".project_header.thumb_container").clone(),
    ".content" : $(".content").clone()
  }
  cache_images();
});