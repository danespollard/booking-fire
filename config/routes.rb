Rails.application.routes.draw do
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]
  resource :registration, only: [ :new, :create ]
  resources :months, only: [ :show ], constraints: { id: /\d{4}-\d{2}/ }
  resource :openings, only: [ :show ]
  resource :openings_range, only: [ :update ]
  resources :templates, only: [ :index, :new, :create, :edit, :update, :destroy ]
  resources :availability_blocks, only: [ :create, :update, :destroy ]

  root "months#show"

  get "up" => "rails/health#show", as: :rails_health_check
end
