Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [ :new, :create ]
  resource :calendar, only: [ :show ]
  resource :openings, only: [ :show ]
  post "availability_blocks/toggle"
  resources :availability_blocks, only: [ :update, :destroy ]

  root "calendars#show"

  get "up" => "rails/health#show", as: :rails_health_check
end
