Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 登入前路徑：增加一個方法"check"，讓使用者不用登入就可對發票
  resources :transactions, only: [:index, :check] do
    collection do
      get :check
    end
  end
  root 'transactions#index'

  # 登入後路徑 : 從user向下延伸路徑
  namespace :user do 
    root 'transactions#index'
    # 網址中的 new 換成 add
    scope(path_names: { new: 'add'}) do
      resources :transactions
    end
  end
end


