// ...
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery-ui/sortable
//= require_tree .


$( document ).ready(function() {
  if ($('.sortable').length > 0) {
    $('.sortable').sortable({
        "axis": 'y',
        "items": '.draggable',
        "cursor": 'move',
        "sort": function(e, ui) {
          ui.item.addClass('active-item-shadow')
        },
        "stop": function(e, ui) {
          ui.item.removeClass('active-item-shadow')
        },
        "update": function(e, ui) {
          new_order = [];
          ui.item.parent().children(".draggable").each(function(i, child) {
            item_id = $(child).data('item-id');
            new_order.push(item_id);
          });


          // TODO: Figure out how to send `new_order` to the server...
          // item_id = ui.item.data('item-id');
          // position = ui.item.index();
          // $.ajax({
          //     "type": 'POST',
          //     "url": '/things/update_row_order',
          //     "dataType": 'json',
          //     "data": {
          //       "image-list": new_order
          //     }
          // })
        }
    });
  }
});
