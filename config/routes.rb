Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :bx_block_account_block do
    resources :accounts do
      post "/verify_email_otp", to: "accounts#verify_email_otp", on: :collection  
      post "/resend_email_otp", to: "accounts#resend_email_otp", on: :collection
    end
  end

  namespace "bx_block_address_block" do 
    get 'fetch_location',to: "addresses#fetch_location"
    get 'location_pincode',to: "addresses#location_pincode"
  end

  namespace :bx_block_login do
    resources :login
  end

  namespace :bx_block_notifications do
    resources :notifications do
      member do
        post :read_notification
      end
      collection do
        delete :destroy_all
        post :read_all_notification
      end
    end
  end
end
