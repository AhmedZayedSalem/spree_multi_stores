$(document).ready(function () {
  'use strict';

  if ($('#product_option_type_ids').length > 0) {
    $('#product_option_type_ids').select2({
      placeholder: Spree.translations.option_type_placeholder,
      multiple: true,
      initSelection: function (element, callback) {
        var url = Spree.url(Spree.routes.option_type_search, {
          ids: element.val(),
          token: Spree.api_key
        });
        return $.getJSON(url, null, function (data) {
          return callback(data);
        });
      },
      ajax: {
        url: Spree.routes.option_type_search,
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
      formatResult: function (option_type) {
        return option_type.presentation + ' (' + option_type.name + ')';
      },
      formatSelection: function (option_type) {
        return option_type.presentation + ' (' + option_type.name + ')';
      }
    });
  }
});
