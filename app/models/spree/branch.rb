module Spree
  class Branch < Spree::Base
    belongs_to :shop
    has_many :branch_products
    has_many :products, through: :branch_products
    def deleted?
      !!deleted_at
    end
  end
end
