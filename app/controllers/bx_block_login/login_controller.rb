class BxBlockLogin::LoginController < ApplicationController
  skip_before_action :authenticate_request
  skip_before_action :verify_authenticity_token

  def create
    @account = BxBlockAccountBlock::Account.find_by(email: login_params[:email])
    if @account.present?
      if @account.activated && @account.authenticate(login_params[:password])
        token = BuilderJsonWebToken::JsonWebToken.encode(user_id: @account.id)
        render json: {
          message: 'Login successful',
          data: {
            id: @account.id,
            token: token
          }
        }, status: :ok
      else
        if @account.activated
          render json: {
            message: 'Invalid email or password. Please check your credentials and try again.'
          }, status: :unauthorized
        else
          render json: {
            message: 'Account is not activated. Please activate your account and try again.'
          }, status: :unauthorized
        end
      end
    else
      render json: {
        message: 'Invalid email or password. Please check your credentials and try again.'
      }, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:account).permit(:email, :password)
  end
end
