Rails.application.routes.draw do

  

  devise_for :users, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  devise_for :admins,  skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

scope module: :public do
  root :to => "homes#top"
  resources :posts,  only: [:index, :new, :show, :edit, :update, :create, :destroy] do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end
  get '/post/hashtag/:name' => 'posts#hashtag'
  get '/post/hashtag' => 'posts#hashtag'

  get "users/quit" => "users#quit"
  patch "users/withdraw" => "users#withdraw"
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
    member do
      get :favorites
    end
    collection do
    get 'search'
    end
  end
  resources :chats, only: [:show, :create]
end

namespace :admin do
  get "/" => "homes#top"
  resources :users, only: [:index, :show, :edit, :update]
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
