Rails.application.routes.draw do
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

  concern :commentable do
    resources :comments, only: [:create, :destroy, :update], shallow: true
  end


  root to: "questions#index"
  resources :questions, concerns: [:votable, :commentable ] do
    resources :answers, concerns: [:votable, :commentable ], shallow: true do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
