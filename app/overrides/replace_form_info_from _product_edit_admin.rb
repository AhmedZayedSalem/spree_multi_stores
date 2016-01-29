Deface::Override.new(:virtual_path => 'spree/admin/products/edit',
  :name => 'replace_form_info_from_product_edit_admin',
  :replace => "erb[loud]:contains('form_for [:admin, @product')",
  :text => "
    <%= form_for [:admin, @shop, @product], :html => { :multipart => true } do |f| %>
  ")
