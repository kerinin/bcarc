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

          action = ui.item.parent().data('action');
          $.ajax({
              "type": 'POST',
              "url": action,
              "dataType": 'json',
              "data": {
                "list-items": new_order
              }
          })
        }
    });
  }
});
