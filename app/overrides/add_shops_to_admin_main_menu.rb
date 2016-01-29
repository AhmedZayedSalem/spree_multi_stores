Deface::Override.new(:virtual_path => 'spree/admin/shared/_main_menu',
  :name => 'add_shops_to_admin_main_menu',
  :insert_before => "erb[silent]:contains('Spree::Admin::ReportsController')",
  :text => "
    <% if can? :admin, Spree::Shop %>
  <ul class='nav nav-sidebar'>
    <%= main_menu_tree Spree.t(:shops), icon: 'th-large', sub_menu: 'shop', url: '#sidebar-shop' %>
  </ul>
<% end %>
")

