require 'rails_helper'
# require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::SmtpCredentialsController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'admin1@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    sign_in @admin
  end
  describe "GET #index" do
    it "shows all subscriptions" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "post #create" do
    it "create new reasons" do
      # debugger
      BxBlockAccountBlock::SmtpSetting.delete_all
      post :create, params: {bx_block_account_block_smtp_setting: {"username"=>"abc", "smtp_password"=>"Abc", "enable_starttls_auto"=>"0"}}
      expect(response).to have_http_status(302)
    end
  end
end