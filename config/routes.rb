Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 登入前路徑：增加一個方法"check"，讓使用者不用登入就可對發票
  resources :transaction_items, only: [:index, :check] do
    collection do
      get :check
    end
  end
  root 'invoices#index'

  # 登入後路徑 : 從user向下延伸路徑
  namespace :user do 
    root 'trades#index'
    resources :transaction_items
  end
end
