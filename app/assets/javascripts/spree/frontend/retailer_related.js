//= require_self
//= require bootstrap-sprockets
//= require jquery
//= require jquery.cookie
//= require jquery.jstree/jquery.jstree
//= require jquery_ujs
//= require jquery-ui/datepicker
//= require jquery-ui/sortable
//= require jquery-ui/autocomplete
//= require modernizr
//= require underscore-min.js
//= require velocity
//= require spree
//= require spree/backend/spree-select2
Spree.routes.option_type_search = Spree.pathFor('api/option_types')
Spree.routes.taxons_search = Spree.pathFor('api/taxons')
Spree.routes.variants_api = Spree.pathFor('api/variants')
Spree.routes.taxon_products_api = Spree.pathFor('api/taxons/products')
Spree.routes.products_api = Spree.pathFor('api/products')
Spree.routes.classifications_api = Spree.pathFor('api/classifications')

Spree.routes.branch_search = function(shop_id) {
   return Spree.pathFor('api/shops/'+ shop_id + '/branches')
}

jQuery(function($) {

  // Add some tips
  $('.with-tip').tooltip();

  $('.js-show-index-filters').click(function(){
    $(".filter-well").slideToggle();
    $(this).parents(".filter-wrap").toggleClass("collapsed");
    $("span.icon", $(this)).toggleClass("icon-chevron-down");
  });

  $(".js-collapse-sidebar").click(function(){
    $(".main-right-sidebar").toggleClass("collapsed");
    $("section.content").toggleClass("sidebar-collapsed");
    $("span.icon", $(this)).toggleClass("icon-chevron-right");
    $("span.icon", $(this)).toggleClass("icon-chevron-left");
  });

  $('#main-sidebar').find('[data-toggle="collapse"]').on('click', function()
    {
      if($(this).find('.icon-chevron-left').length == 1){
        $(this).find('.icon-chevron-left').removeClass('icon-chevron-left').addClass('icon-chevron-down');
      }
      else {
        $(this).find('.icon-chevron-down').removeClass('icon-chevron-down').addClass('icon-chevron-left');
      }
    }
  )

  // Sidebar nav toggle functionality
  var sidebar_toggle = $('#sidebar-toggle');

  sidebar_toggle.on('click', function(){
    var wrapper = $('#wrapper');
    var main    = $('#main-part');

    if(wrapper.hasClass('sidebar-minimized')){
      wrapper.removeClass('sidebar-minimized');
      main
        .removeClass('col-sm-12 col-md-12 sidebar-collapsed')
        .addClass('col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2');
      $.cookie('sidebar-minimized', 'false', { path: '/admin' });
    }
    else {
      wrapper.addClass('sidebar-minimized');
      main
        .removeClass('col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2')
        .addClass('col-sm-12 col-md-12 sidebar-collapsed');
      $.cookie('sidebar-minimized', 'true', { path: '/admin' });
    }
  });

  $('.sidebar-menu-item').mouseover(function(){
    if($('#wrapper').hasClass('sidebar-minimized')){
      $(this).addClass('menu-active');
      $(this).find('ul.nav').addClass('submenu-active');
    }
  });
  $('.sidebar-menu-item').mouseout(function(){
    if($('#wrapper').hasClass('sidebar-minimized')){
      $(this).removeClass('menu-active');
      $(this).find('ul.nav').removeClass('submenu-active');
    }
  });

  // TODO: remove this js temp behaviour and fix this decent
  // Temp quick search
  // When there was a search term, copy it
  $(".js-quick-search").val($(".js-quick-search-target").val());
  // Catch the quick search form submit and submit the real form
  $("#quick-search").submit(function(){
    $(".js-quick-search-target").val($(".js-quick-search").val());
    $("#table-filter form").submit();
    return false;
  });

  // Main menu active item submenu show
  var active_item = $('#sidebar').find('.selected');
  active_item.parent().addClass('in');
  active_item.parent().prev()
    .find('.icon-chevron-left')
    .removeClass('icon-chevron-left')
    .addClass('icon-chevron-down');

  // Replace ▼ and ▲ in sort_link with nicer icons
  $(".sort_link").each(function(){
    // Remove the &nbsp; in the text
    var sort_link_text = $(this).text().replace('\xA0', '');

    if(sort_link_text.indexOf("▼") >= 0){
      $(this).text(sort_link_text.replace("▼",""));
      $(this).append('<span class="icon icon-chevron-down"></span>');
    } else if(sort_link_text.indexOf("▲") >= 0){
      $(this).text(sort_link_text.replace("▲",""));
      $(this).append('<span class="icon icon-chevron-up"></span>');
    }
  });

  // Clickable ransack filters
  $(".js-add-filter").click(function() {
    var ransack_field = $(this).data("ransack-field");
    var ransack_value = $(this).data("ransack-value");

    $("#" + ransack_field).val(ransack_value);
    $("#table-filter form").submit();
  });

  $(document).on("click", ".js-delete-filter", function() {
    var ransack_field = $(this).parents(".js-filter").data("ransack-field");

    $("#" + ransack_field).val('');
    $("#table-filter form").submit();
  });

  $(".js-filterable").each(function() {
    var $this = $(this);

    if ($this.val()) {
      var ransack_value, filter;
      var ransack_field = $this.attr("id");
      var label = $('label[for="' + ransack_field + '"]');

      if ($this.is("select")) {
        ransack_value = $this.find('option:selected').text();
      } else {
        ransack_value = $this.val();
      }

      label = label.text() + ': ' + ransack_value;
      filter = '<span class="js-filter label label-default" data-ransack-field="' + ransack_field + '">' + label + '<span class="icon icon-delete js-delete-filter"></span></span>';

      $(".js-filters").append(filter).show();
    }
  });

  // Enable sidebar toggle
  $("[data-toggle='offcanvas']").click(function(e) {
    e.preventDefault();

    // If window is small enough, enable sidebar push menu
    if ($(window).width() <= 992) {
      $('.row-offcanvas').toggleClass('active');
      $('.left-side').removeClass("collapse-left");
      $(".right-side").removeClass("strech");
      $('.row-offcanvas').toggleClass("relative");
    } else {
      // Else, enable content streching
      $('.left-side').toggleClass("collapse-left");
      $(".right-side").toggleClass("strech");
    }
  });

  // Make flash messages dissapear
  setTimeout('$(".alert-auto-dissapear").slideUp()', 5000);

});


$.fn.visible = function(cond) { this[cond ? 'show' : 'hide' ]() };

show_flash = function(type, message) {
  var flash_div = $('.flash.' + type);
  if (flash_div.length == 0) {
    flash_div = $('<div class="alert alert-' + type + '" />');
    $('#content').prepend(flash_div);
  }
  flash_div.html(message).show().delay(5000).slideUp();
}


// Apply to individual radio button that makes another element visible when checked
$.fn.radioControlsVisibilityOfElement = function(dependentElementSelector){
  if(!this.get(0)){ return  }
  showValue = this.get(0).value;
  radioGroup = $("input[name='" + this.get(0).name + "']");
  radioGroup.each(function(){
    $(this).click(function(){
      $(dependentElementSelector).visible(this.checked && this.value == showValue)
    });
    if(this.checked){ this.click() }
  });
}

handle_date_picker_fields = function(){
  $('.datepicker').datepicker({
    
    dateFormat: Spree.translations.date_picker,
    dayNames: Spree.translations.abbr_day_names,
    dayNamesMin: Spree.translations.abbr_day_names,
    firstDay: Spree.translations.first_day,
    monthNames: Spree.translations.month_names,
    prevText: Spree.translations.previous,
    nextText: Spree.translations.next,
    showOn: "focus"
  });



  // Correctly display range dates
  $('.date-range-filter .datepicker-from').datepicker('option', 'onSelect', function(selectedDate) {
    $(".date-range-filter .datepicker-to" ).datepicker( "option", "minDate", selectedDate );
  });
  $('.date-range-filter .datepicker-to').datepicker('option', 'onSelect', function(selectedDate) {
    $(".date-range-filter .datepicker-from" ).datepicker( "option", "maxDate", selectedDate );
  });
}

handle_date_picker_fields_register = function(){
  $('.datepickerreg').datepicker({
    yearRange: "1900:2016",
  changeMonth: true,
      changeYear: true,
    showOn: "focus"
  });
}

$(document).ready(function(){
  handle_date_picker_fields();
  handle_date_picker_fields_register(); 
  $(".observe_field").on('change', function() {
    target = $(this).data("update");
    $(target).hide();
    $.ajax({ dataType: 'html',
             url: $(this).data("base-url")+encodeURIComponent($(this).val()),
             type: 'get',
             success: function(data){
               $(target).html(data);
               $(target).show();
             }
    });
  });

  var uniqueId = 1;
  $('.spree_add_fields').click(function() {
    var target = $(this).data("target");
    var new_table_row = $(target + ' tr:visible:last').clone();
    var new_id = new Date().getTime() + (uniqueId++);
    new_table_row.find("input, select").each(function () {
      var el = $(this);
      el.val("");
      el.prop("id", el.prop("id").replace(/\d+/, new_id))
      el.prop("name", el.prop("name").replace(/\d+/, new_id))
    })
    // When cloning a new row, set the href of all icons to be an empty "#"
    // This is so that clicking on them does not perform the actions for the
    // duplicated row
    new_table_row.find("a").each(function () {
      var el = $(this);
      el.prop('href', '#');
    })
    $(target).prepend(new_table_row);
  })

  $('body').on('click', '.delete-resource', function() {
    var el = $(this);
    if (confirm(el.data("confirm"))) {
      $.ajax({
        type: 'POST',
        url: $(this).prop("href"),
        data: {
          _method: 'delete',
          authenticity_token: AUTH_TOKEN
        },
        dataType: 'script',
        success: function(response) {
          if(el.parents(".product-list-item"))
            {
              el.parents(".product-list-item").fadeOut('hide', function() {
            $(this).remove();
          });
            } else if(el.parents("tr")){
          el.parents("tr").fadeOut('hide', function() {
            $(this).remove();
          });
          }
        },
        error: function(response, textStatus, errorThrown) {
          show_flash('error', response.responseText);
        }
      });
    }
    return false;
  });

  $('body').on('click', 'a.spree_remove_fields', function() {
    el = $(this);
    el.prev("input[type=hidden]").val("1");
    el.closest(".fields").hide();
    if (el.prop("href").substr(-1) == '#') {
      el.parents("tr").fadeOut('hide');
    }else if (el.prop("href")) {
      $.ajax({
        type: 'POST',
        url: el.prop("href"),
        data: {
          _method: 'delete',
          authenticity_token: AUTH_TOKEN
        },
        success: function(response) {
          el.parents("tr").fadeOut('hide');
        },
        error: function(response, textStatus, errorThrown) {
          show_flash('error', response.responseText);
        }

      })
    }
    return false;
  });

  $('body').on('click', '.select_properties_from_prototype', function(){
    $("#busy_indicator").show();
    var clicked_link = $(this);
    $.ajax({ dataType: 'script', url: clicked_link.prop("href"), type: 'get',
        success: function(data){
          clicked_link.parent("td").parent("tr").hide();
          $("#busy_indicator").hide();
        }
    });
    return false;
  });

  // Fix sortable helper
  var fixHelper = function(e, ui) {
      ui.children().each(function() {
          $(this).width($(this).width());
      });
      return ui;
  };

  $('table.sortable').ready(function(){
    var td_count = $(this).find('tbody tr:first-child td').length
    $('table.sortable tbody').sortable(
      {
        handle: '.handle',
        helper: fixHelper,
        placeholder: 'ui-sortable-placeholder',
        update: function(event, ui) {
          $("#progress").show();
          positions = {};
          $.each($('table.sortable tbody tr'), function(position, obj){
            reg = /spree_(\w+_?)+_(\d+)/;
            parts = reg.exec($(obj).prop('id'));
            if (parts) {
              positions['positions['+parts[2]+']'] = position;
            }
          });
          $.ajax({
            type: 'POST',
            dataType: 'script',
            url: $(ui.item).closest("table.sortable").data("sortable-link"),
            data: positions,
            success: function(data){ $("#progress").hide(); }
          });
        },
        start: function (event, ui) {
          // Set correct height for placehoder (from dragged tr)
          ui.placeholder.height(ui.item.height())
          // Fix placeholder content to make it correct width
          ui.placeholder.html("<td colspan='"+(td_count-1)+"'></td><td class='actions'></td>")
        },
        stop: function (event, ui) {
          // Fix odd/even classes after reorder
          $("table.sortable tr:even").removeClass("odd even").addClass("even");
          $("table.sortable tr:odd").removeClass("odd even").addClass("odd");
        }

      });
  });

  $('a.dismiss').click(function() {
    $(this).parent().fadeOut();
  });

  window.Spree.advanceOrder = function() {
      $.ajax({
          type: "PUT",
          async: false,
          data: {
            token: Spree.api_key
          },
          url: Spree.url(Spree.routes.checkouts_api + "/" + order_number + "/advance")
      }).done(function() {
          window.location.reload();
      });
  }
});
