Rails.application.routes.draw do
  get 'tags/show'
  get 'tags/index'
  devise_for :users

  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    resources :tags, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
  	get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/search', to: 'searches#search'

  get 'books/search/sort_new', to: 'books#search', as: 'sort_new'
  get 'books/search/sort_join', to: 'books#search', as: 'sort_join'
  get "search_book" => "books#search_book"
end
