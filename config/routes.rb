Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :transactions, only: [:index, :check] do
    collection do
      get :check
    end
  end
  root 'transactions#index'

  namespace :users do 
    root 'transactions#index'
    # 網址中的 new 換成 add
    scope(path_names: { new: 'add'}) do
      resources :transactions do 
        collection do
          get :point
        end
      end
    end
  end
end


