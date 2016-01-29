Deface::Override.new(:virtual_path => 'spree/admin/products/index',
  :name => 'add_admin_shop_sidebar_to_product',
  :insert_before => "erb[silent]:contains('content_for :page_title do')",
  :text => "
   <%= render partial: 'spree/admin/shared/shop_tabs', locals: {current: :products} %>
  ")
