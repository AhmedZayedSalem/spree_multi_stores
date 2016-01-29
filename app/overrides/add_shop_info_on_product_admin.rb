Deface::Override.new(:virtual_path => 'spree/admin/products/new',
  :name => 'add_shop_info_on_product_admin',
  :replace => "erb[loud]:contains('form_for [:admin, @product')",
  :text => "
    <%= form_for [:admin, @shop, @product], :html => { :multipart => true } do |f| %>
  ")
