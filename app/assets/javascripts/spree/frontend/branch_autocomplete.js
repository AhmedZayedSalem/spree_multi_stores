$(document).ready(function () {
  'use strict';
   var shop_id =  $('#current-shop-id').text();
  if ($('#product_branch_ids').length > 0) {
    $('#product_branch_ids').select2({
      placeholder: Spree.translations.branch_placeholder,
      multiple: true,
      initSelection: function (element, callback) {
        var url = Spree.url(Spree.routes.branch_search(shop_id), {
          ids: element.val(),
          token: Spree.api_key
        });
        return $.getJSON(url, null, function (data) {
          return callback(data);
        });
      },
      ajax: {
        url: Spree.routes.branch_search(shop_id),
        quietMillis: 200,
        datatype: 'json',
        data: function (term) {
          return {
            q: {
              name_cont: term
            },
            token: Spree.api_key
          };
        },
        results: function (data) {
          return {
            results: data
          };
        }
      },
      formatResult: function (branch) {
        return branch.name ;
      },
      formatSelection: function (branch) {
        return branch.name;
      }
    });
  }
});
