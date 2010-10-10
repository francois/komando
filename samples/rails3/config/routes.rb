App::Application.routes.draw do
  resources :users
  resources :sessions, :only => %w(new create destroy)

  root :to => "sessions#new"
end
