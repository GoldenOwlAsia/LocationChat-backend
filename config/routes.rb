Rails.application.routes.draw do
  root to: 'visitors#index'
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
        resources :sessions, only: [:create] do
          collection do
            delete :destroy
          end
        end
        resources :tokens, only: [:create]
        resources :channels
      end
    end
  end
end
