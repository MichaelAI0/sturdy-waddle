# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  require "sidekiq/web"

  scope :monitoring do
    # Sidekiq Basic Auth from routes on production environment
    if Rails.env.production?
      Sidekiq::Web.use Rack::Auth::Basic do |username, password|
        ActiveSupport::SecurityUtils.secure_compare(
          ::Digest::SHA256.hexdigest(username),
          ::Digest::SHA256.hexdigest(
            Rails.application.credentials.sidekiq[:auth_username]
          )
        ) &
          ActiveSupport::SecurityUtils.secure_compare(
            ::Digest::SHA256.hexdigest(password),
            ::Digest::SHA256.hexdigest(
              Rails.application.credentials.sidekiq[:auth_password]
            )
          )
      end
    end
    mount Sidekiq::Web, at: "/sidekiq"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :users do
        post :login
        delete :logout
        get :me
        post :create
        patch :update
      end
      resources :tweets do
        member do
          post :like
          delete :unlike
          post :retweet
          delete :unretweet
        end
      end
      resources :likes, only: %i[create destroy]
      resources :follows, only: %i[create destroy]
      resources :retweets, only: %i[create destroy]
    end
  end
end
