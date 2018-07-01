Rails.application.routes.draw do


  concern :votable do
    member do
      post :vote_count_up
      post :vote_count_down
    end
  end


  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"
  resources :questions, concerns: [:votable ] do
    resources :answers, concerns: [:votable ], shallow: true do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
