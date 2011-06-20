// If the URL has been reloaded from a gimpy browser (url#/url), redirect before it renders
if( window.location.hash ) window.location.href = window.location.hash.replace(/^#/,'');

// List of HTML content for insertion, indexed by URL
var content_list = {}
var current_DOM_path = null

function show_spinner() {
  $('.content').replaceWith( $('.spinner').clone().removeClass('hidden').addClass('current') );
  $('.spinner.current').wrap("<div class='content'>");
}

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
    show_spinner();
    cache_path(path);
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
  if( window.location.hash ) load_path( window.location.hash.replace(/^#/,'') );
  else load_path( window.location.href);
  cache_images();
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

function init() {
  // Cache the current page
  current_DOM_path = window.location.href;
  content_list[window.location.href] = {
    ".project_header.thumb_container" : $(".project_header.thumb_container").clone(),
    ".content" : $(".content").clone()
  }
  
  // Init the history
  $.htmlhistory.init({ interceptLinks: false });    

  // Bind behaviors to the history plugin
  $('body').delegate('a[rel=prerender]', 'click', function(e) {
    $.htmlhistory.changeTo( $(this).attr('href') );
    e.preventDefault();
  })
  $(window).bind('htmlhistory', refresh_DOM);

  // Cache the next couple images
  cache_images();  
}

$(document).ready( function() {
  // This keeps the browser spinner from going while the ajax loads
  // May also avoid some page loads if people click back quickly
  var t=setTimeout(init,1500);
});