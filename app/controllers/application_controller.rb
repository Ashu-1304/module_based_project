class ApplicationController < ActionController::Base
  before_action :authenticate_request
  protect_from_forgery with: :null_session

  include ActionView::Layouts
  protect_from_forgery unless: -> { request.format.json? }

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate_request
    header = request.headers["token"]
    token = header.split(" ").last if header

    if token
      begin
        @decoded = BuilderJsonWebToken::JsonWebToken.decode(token)
        @current_user = BxBlockAccountBlock::Account.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: "Account not found: #{e.message}" }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: "Invalid token: #{e.message}" }, status: :unauthorized
      end
    else
      render json: { errors: "Missing token" }, status: :unauthorized
    end
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to admin_dashboard_path
  end
end
