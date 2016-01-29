Deface::Override.new(:virtual_path => 'spree/admin/products/index',
  :name => 'edit_link_to_edit_in_admin_product_index',
  :replace => "erb[loud]:contains('Spree.t(:new_product), new_object_url')",
  :text => "
     <%= button_link_to Spree.t(:new_product), spree.new_admin_shop_product_url(@shop), { :class => 'btn-success', :icon => 'add', :id => 'admin_new_product' } %>
  ")
