Rails.application.routes.draw do
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
    get 'all_record',to: "addresses#all_record"
  end

  namespace :bx_block_login do
    resources :login
  end
  
end
