module Spree
  Product.class_eval do

    belongs_to :shop 
    has_many :branch_products
    has_many :branches, through: :branch_products

  end
end
