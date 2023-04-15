Rails.application.routes.draw do
  resources :users, default: { format: :json }
  resources :companies, default: { format: :json }
  resources :employees, default: { format: :json }
  resources :periods, default: { format: :json }
  resources :payrolls, default: { format: :json }
  post '/sessions', to: 'sessions#create'
end
