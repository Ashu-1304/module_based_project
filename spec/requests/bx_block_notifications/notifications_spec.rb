require 'rails_helper'

RSpec.describe BxBlockNotifications::Notification, type: :request do

  before(:each) do
    @account = BxBlockAccountBlock::Account.create(first_name: 'prashant', last_name: 'sharma', email: 'prashant@yopmail.com', activated: true, password: 'User@1234')
    @notification = BxBlockNotifications::Notification.create(title: "Welcome Notification", message: "Welcome, Your account has been successfully created.", account_id: @account.id)
    @token = BuilderJsonWebToken::JsonWebToken.encode(user_id: @account.id)
  end

  describe "GET#index" do
    context "when get all notifications" do
      it "returns successful response" do
        get "/bx_block_notifications/notifications", headers: { token: @token}
        expect(response).to have_http_status(:ok)
      end

      it "returns not found response" do
        @account.notifications.destroy_all
        get "/bx_block_notifications/notifications", headers: { token: @token}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE#destroy_all" do
    context "when delete all notification" do
      it "returns successful response" do
        delete "/bx_block_notifications/notifications/destroy_all", headers: { token: @token}
        expect(response). to have_http_status(:ok)
      end

      it "returns not found response" do
        @account.notifications.destroy_all
        delete "/bx_block_notifications/notifications/destroy_all", headers: { token: @token}
        expect(response). to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE#destroy" do
    context "when delete notification" do
      it "returns successful response" do
        delete "/bx_block_notifications/notifications/#{@notification.id}", headers: { token: @token}
        expect(response). to have_http_status(:ok)
      end

      it "returns not found response" do
        delete "/bx_block_notifications/notifications/999", headers: { token: @token}
        expect(response). to have_http_status(:not_found)
      end
    end
  end

  describe "POST#read_notification" do
    context "when read notification" do
      it "returns successful response" do
        post "/bx_block_notifications/notifications/#{@notification.id}/read_notification", headers: { token: @token}
        expect(response). to have_http_status(:ok)
      end

      it "returns not found response" do
        post "/bx_block_notifications/notifications/999/read_notification", headers: { token: @token}
        expect(response). to have_http_status(:not_found)
      end
    end
  end

  describe "POST#read_all_notification" do
    context "when read all notification" do
      it "returns successful response" do
        post "/bx_block_notifications/notifications/read_all_notification", params: { read_all: true }, headers: { token: @token}
        expect(response). to have_http_status(:ok)
      end

      it "returns not found response" do
        @account.notifications.destroy_all
        post "/bx_block_notifications/notifications/read_all_notification", headers: { token: @token}
        expect(response). to have_http_status(:not_found)
      end
    end
  end
end