require 'sidekiq/web'
Rails.application.routes.draw do
  get 'subscription/create'
  get 'subscription/destroy'
  authenticate :user, lambda {|u| u.admin?} do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks'}

  get 'comment/create'
  get 'comment/destroy'
  get 'comment/update'
  concern :votable do
    member do
      post :vote_count_up
      post :vote_count_down
    end
  end

  devise_scope :user do
    post '/register' => 'omniauth_callbacks#register'
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy, :update], shallow: true
  end


  root to: "questions#index"
  resources :questions, concerns: [:votable, :commentable ] do
    resources :answers, concerns: [:votable, :commentable ], shallow: true do
      patch :best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create], shallow: true do
        resources :answers, only: [:index, :show, :create]
      end

    end
  end

  resources :subscriptions, only: [:create, :destroy]
  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
