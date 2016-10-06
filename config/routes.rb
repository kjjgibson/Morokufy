Rails.application.routes.draw do

  namespace :web_hooks do
    resources :semaphore_web_hooks, only: %i(create index)
  end

end
