SpreeMultiStores
================

ATTENTION... Still under development, expect the unexpected !

Spree extension that provides a multi-shop/ multi-vendor functionality, it is based on Spree 3.0.

The "Shop" entity is accessed in the following way:

http://localhost:3000/shops/shop-slug

Functionality:

Shop owners/retailers can register as a retailer, after registration a shop account/page is created for that user, from which, he can create products and configure/edit everything for them (images, product_properties, variants,, etc..)

Shop owners/retailers can also add "branches" to their shop which include details about the branch (address, contacts, etc..), and products can exist in all or some branches.


This is all done from the front-end if the user has the retailer ability (he is not redirected to admin backend views)


The Admin user who has access to the backend can see all shops, their branches, products, and edit all of them




Installation
------------

Add spree_multi_stores to your Gemfile:

```ruby
gem 'spree_multi_stores', '3.0.5', git: 'https://github.com/AhmedZayedSalem/spree_multi_stores.git'
```

Bundle your dependencies and run the installation generator:

```shell
bundle install
rails g spree_multi_stores:install
```

login as Admin and then go to:

http://localhost:3000/admin/roles

click "New Role" to create the new role "retailer"

now you should be able to try out the extension !

Testing
-------

Unit test creation was not done as of 08/02/2016 , kindly support !


```



Copyright (c) 2015 AhmedZayedSalem, released under the New BSD License
