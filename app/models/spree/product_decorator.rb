module Spree
  Product.class_eval do

    belongs_to :shop 
    has_many :branch_products
    has_many :branches, through: :branch_products
    preference :new_arrival, :boolean, :default => true
    preference :on_sale, :boolean, :default => false
    preference :on_trial, :boolean, :default => false
    preference :returnable, :boolean, :default => false
  end
end
