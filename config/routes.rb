Rails.application.routes.draw do

  resources :web_hooks, only: %i(create)

  namespace :hipchat do
    resources :hipchat_slash, only: %i(create)
  end

end
