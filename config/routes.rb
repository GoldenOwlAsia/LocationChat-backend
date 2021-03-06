Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api do
  namespace :v1 do
    namespace :user do
      get 'friends/index'
      end
    end
  end

  namespace :api do
  namespace :v1 do
    namespace :user do
      get 'friends/create'
      end
    end
  end

  namespace :api do
  namespace :v1 do
    namespace :user do
      get 'friends/destroy'
      end
    end
  end

  root to: 'admin/users#index'
  devise_for :users
  resources :users

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      namespace :admin do
        resources :users, only: [:index, :show, :create, :update] do
          member do
            patch :activate
            patch :deactivate
          end
        end
      end

      namespace :user do
        resource :oauth, only: [:create]
        resources :profiles do
          collection do
            get :check
          end
        end
        resources :oauth
        resources :settings, only: [:update, :show] do
          collection do
            get :show
            put :update
          end
        end

        resources :sessions, only: [:create] do
          collection do
            delete :destroy
          end
        end
        resources :tokens, only: [:create, :show]
        resources :channels do
          resources :members, module: 'channels', only: [:index, :create] do
            collection do
              delete :destroy
            end
          end
          collection do
            delete :destroy
          end
          member do
            get :check_favorite
            get :uncheck_favorite
          end
        end
        resources :friends, only: [:index, :create] do
          collection do
            delete :destroy
            post :send_add_friend
            post :accept_add_friend
            post :reject_add_friend
            post :send_message
          end
        end
      end
    end
  end
end
