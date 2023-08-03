Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to:'pages#about'

  resources :articles do
    collection do
      get 'search'
    end
  end
  
  get 'signup', to:'users#new'
  resources :users, except: [:new]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :likes, only: [:create, :destroy]
end


