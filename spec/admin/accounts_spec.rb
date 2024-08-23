require 'rails_helper'
include Warden::Test::Helpers

describe Admin::AccountsController, type: :controller do

  include Devise::Test::ControllerHelpers
  render_views
  before(:each) do
    @admin = AdminUser.create(email: "admin@example.com")
    @admin.password = "password"
    @admin.role = "admin"
    @admin.save
    sign_in @admin
    @account = BxBlockAccountBlock::Account.create(first_name: 'prashant', last_name: 'sharma', email: 'prashant@yopmail.com', activated: true, password: 'User@1234') 
  end
  let(:account_params) do
    {
      account: {
        first_name: @account.first_name,
        last_name: @account.last_name,
        email: @account.email,
        password: @account.password,
        password_confirmation: @account.password
      }
    }
  end

  describe 'create user' do
    it 'successful creation' do
      post :new, params: account_params
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show user' do
    it 'successful show' do
      get :show, params: {id: @account.id}
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'show all user' do
    it 'shows the accounts' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

end