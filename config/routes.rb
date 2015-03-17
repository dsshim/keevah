Rails.application.routes.draw do

  get "/menu", to: "items#index"

  get "/cart", to: "cart#index"
  post "/cart", to: "cart#create"
  delete "/cart", to: "cart#delete"
  put "/cart", to: "cart#update"

  resources :orders, only: [:create, :index]

  resources :categories do
    resources :items
  end

  get "login" => "sessions#new", :as => "login"
  post "login" => "sessions#create"
  get '/logout', to: 'sessions#destroy'
  delete 'logout', to: 'sessions#destroy'

  resources :users, only: [:show]
  resources :items

  namespace 'admin' do
    get '', to: 'dashboard#index', as: '/'
  end

  root 'home#index'

end
