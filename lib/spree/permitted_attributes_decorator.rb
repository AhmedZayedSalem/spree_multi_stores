Spree::PermittedAttributes.class_eval do  

    mattr_reader :shop_attributes

    class_variable_set(:@@shop_attributes,
                     [
                       :id,
                       :name,
                       :description
                     ])
end
