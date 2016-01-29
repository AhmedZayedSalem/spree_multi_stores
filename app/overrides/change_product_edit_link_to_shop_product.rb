Deface::Override.new(:virtual_path => 'spree/admin/products/index',
  :name => 'change_product_edit_link_to_shop_product',
  :replace => "erb[loud]:contains('edit_admin_product_path(product)')",
  :text => "
     <%= link_to product.try(:name), edit_admin_shop_product_path(@shop,product) %>
  ")
