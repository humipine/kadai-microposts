Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  
  # 以下は、resources :sessions, only: [:new, :create, :destroy] としても同じ
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  
  # Edited on 2017/06/23 to enable editing, deleting user's records (start) <<
  # resources :users, only: [:index, :show, :new, :create]
  resources :users do
    # member ブロックの方は特定のデータを対象としたアクションを記述
    # リクエストでIDパラメータを指定する必要がある
    member do
      get :followings
      get :followers
      get :favoritizings
    end 
    
    # collection ブロックには全てのデータを対象としたアクションを記述
    collection do
      get :search
    end
  end
  
  # Edited Ends >>
  
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
end