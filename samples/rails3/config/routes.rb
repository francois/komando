App::Application.routes.draw do
  resources :invitations
  resources :sessions, :only => %w(new create destroy)

  root :to => "sessions#new"
end
