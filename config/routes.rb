Rails.application.routes.draw do


  
  get 'worksheet/get_worksheet'

  devise_for :users
  get 'short_choice_questions/index'
  root to: "home#index"

  resources :topics
  resources :short_choice_questions
  resources :chapters do 
    get :get_topics_list
  end
  resources :subjects
  resources :standards do 
    get :get_chapters_list
  end

  get "/" => "home#index"

  namespace :api, :defaults => {:format => :json} do  
    resources :standards do 
      collection do
        get :get_standards
      end
    end

    resources :streams do 
      collection do
        get :get_streams
      end
    end

    resources :diagnostic_tests do 
      collection do
        get   :get_test
        post  :test_attempt
      end
    end

    resources :worksheet do 
      collection do 
        post  :worksheet_attempt,:get_worksheet,:get_intro
      end
    end

    resources :users do
      collection do
        post :register
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
