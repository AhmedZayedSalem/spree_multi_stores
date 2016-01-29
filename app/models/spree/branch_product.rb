module Spree
  class BranchProduct < Spree::Base
    belongs_to :branch
    belongs_to :product    
  end
end
