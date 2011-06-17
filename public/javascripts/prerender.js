// List of HTML content for insertion, indexed by URL
var content_list = {}

function handle_prerender(e) {
  // Make sure we're working on the element we expect
  elem = $(e.target).closest('a[rel=prerender]')
  
  // If the requested URL has been cached (should return false if still being cached)
  if( content = content_list[elem.attr('href')] ) {
    // Replace the local content with the cached content
    // Request returns a script with a hash of selector:content pairs
    for( var selector in content) {
      $(selector).replaceWith(content[selector]);
    }
    
    // Make sure the new content has the same behavior
    update_behavior();
    
    // Cache any images that haven't been downloaded yet
    cache_images();
    
    // Don't go follow the link...
    e.preventDefault();
  }
}

function update_behavior(){
  $("a[rel=prerender]").click(handle_prerender);
}

function cache_image( elem ) {
  var href = $(elem).attr('href');
  
  // Only cache if a request hasn't been sent
  if( !content_list[href] ) {
    content_list[ href ] = null;
    // Otherwise, send and XHR request for the URL listed
    $.getScript( href );
  }  
}

function cache_images( scope ) {
  // Cache the next 2 images
  $('a.current_image').nextAll('a[rel=prerender]:lt(4)').each( function(i,elem) {
    cache_image(elem);
  });  
  // And cache the first 2 images
  $('a[rel=prerender]:lt(2)').each( function(e,elem) {
    cache_image(elem);  
  });
}

$(document).ready( function() {
  // Cache the current page
  content_list[window.location.pathname] = {
    ".project_header.thumb_container" : $(".project_header.thumb_container").clone(),
    ".content" : $(".content").clone()
  }
  update_behavior();
  cache_images();
});