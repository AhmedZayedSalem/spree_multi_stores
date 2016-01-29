Spree::Core::Engine.routes.draw do
  # Add your extension routes here
    
  resources :shops  do
   delete '/product_properties/:id', to: "product_properties#destroy", as: :product_property
    resources :branches do
      collection do
        post :update_positions
      end
    end 
    resources :option_types do
      collection do
        post :update_positions
        post :update_values_positions
      end
    end
    resources :products do
      resources :product_properties do
        collection do
          post :update_positions
        end
      end
      resources :images do
        collection do
          post :update_positions
        end
      end
      member do
        get :clone
        get :stock
      end
      resources :variants do
        collection do
          post :update_positions
        end
      end
      resources :variants_including_master, only: [:update]
    end       
  end
  resources :prototypes do
    member do
      get :select
    end

    collection do
      get :available
    end
  end
  get ':id/p', to: 'products#show', as: :productt
  get ':id/s', to: 'shops#show', as: :shopp
  get '/:id/u', to: 'products#show', as: :shopp_productt
  
  devise_scope :spree_user do
    get '/sell' => 'retailer_registrations#new', :as => :sell
    post '/sell' => 'retailer_registrations#create', :as => :retailer_registration
  end
  namespace :api, defaults: { format: 'json' } do
     resources :branches
     resources :shops do
       resources :branches
     end
  end
  namespace :admin do
     resources :shops  do
       resources :branches do
         collection do
           post :update_positions
         end
       end 
       resources :products do
         resources :product_properties do
           collection do
             post :update_positions
           end
         end
         resources :images do
           collection do
             post :update_positions
           end
         end
         member do
           get :clone
           get :stock
         end
         resources :variants do
           collection do
             post :update_positions
           end
         end
         resources :variants_including_master, only: [:update]
       end       
     end

  end

end
