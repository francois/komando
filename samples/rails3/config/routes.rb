App::Application.routes.draw do
  resources :invitations, :only => %w(new create edit update)
  resources :sessions, :only => %w(new create destroy)

  root :to => "sessions#new"
end
