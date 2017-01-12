Rails.application.routes.draw do

  namespace :web_hooks do
    resources :semaphore_web_hooks, only: %i(create)
  end

  namespace :hipchat do
    resources :hipchat_slash, only: %i(create)
  end

end
