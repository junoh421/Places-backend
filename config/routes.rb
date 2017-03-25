Rails.application.routes.draw do
  devise_for :users
  devise_for :users, defaults: { format: :json },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show]
    end
  end
end
