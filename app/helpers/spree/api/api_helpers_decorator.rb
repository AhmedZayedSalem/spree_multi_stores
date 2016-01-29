Spree::Api::ApiHelpers.class_eval do  
    mattr_reader :branch_attributes
    mattr_reader :shop_attributes
    class_variable_set(:@@branch_attributes,
                     [
                       :id,
                       :name,
                       :address,
                       :phone_number,
                       :opening_hours
                     ])
    class_variable_set(:@@shop_attributes,
                     [
                       :id,
                       :name,
                       :description
                     ])
end
