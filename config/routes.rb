Rails.application.routes.draw do

  resources :web_hooks, only: %i(create)

end
