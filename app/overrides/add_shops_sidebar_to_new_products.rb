Deface::Override.new(:virtual_path => 'spree/admin/products/new',
  :name => 'add_shops_sidebar_to_new_products',
  :insert_before => "erb[loud]:contains('/admin/shared/error_messages')",
  :text => "
   <%= render partial: 'spree/admin/shared/shop_tabs', locals: {current: :products} %>
  ")
