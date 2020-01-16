Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :transactions, only: [:index] do
    collection do
      post :prizes
    end
  end
  root 'transactions#index'

  namespace :users do 
    root 'transactions#index'
    resources :incomes
    # 網址 new 換成 add
    scope(path_names: { new: 'add'}) do
      resources :transactions do 
        collection do 
          post :act
          get :redeem
        end
      end
    end
  end
end
