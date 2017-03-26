Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  } do
    authenticated :user do
      delete 'sign_out', :to => 'devise/sessions#destroy'
      root "projects#index", as: :authenticated_root
      resources :users
    end
    unauthenticated :user do
      match '/sessions/user', to: 'devise/sessions#create', via: :post
    end
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show]
    end
  end
end
