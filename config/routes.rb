# config/routes.rb

Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'

  resources :articles do
    collection do
      get 'search'
      get 'top_posts', to: 'articles#top_posts'
      get 'topics', to: 'articles#all_topics'
      
    end

    member do
      get 'similar_user_articles', to: 'articles#similar_user_articles'
    end

    resources :comments, only: [:index, :create]
    resources :likes, only: [:create, :destroy]
    get 'likes', on: :member, to: 'likes#index'
  end

  patch 'articles/:id', to: 'articles#update'
  resources :comments, only: [:show, :update, :destroy]

  post 'signup', to: 'users#create' 

  resources :users, except: [:new]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'payments/revenue/:article_limit', to: 'payments#revenue'
  post 'payments/distribute/:total_revenue', to: 'payments#distribute'
end
