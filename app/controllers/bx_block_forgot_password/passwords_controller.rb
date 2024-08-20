class BxBlockForgotPassword::PasswordsController < ApplicationController
    skip_before_action :authenticate_request

    def create
        
        if create_params[:token].present? && create_params[:new_password].present?
          # Try to decode token with OTP information
          begin
            header=create_params[:token]
            token = header.split(" ").last if header
            token = BuilderJsonWebToken::JsonWebToken.complex_decode(token)
          rescue JWT::DecodeError => e
            return render json: {
              errors: [{
                token: 'Invalid token',
              }],
            }, status: :bad_request
          end
  
          # Try to get OTP object from token
          begin
            otp = token.type.constantize.find(token.id)
          rescue ActiveRecord::RecordNotFound => e
            return render json: {
              errors: [{
                otp: 'Token invalid',
              }],
            }, status: :unprocessable_entity
          end
  
          # Check if OTP was validated
          if otp.pin == create_params[:otp_code].to_i
            otp.activated = true
            otp.save
            # render json: {
            #   messages: [{
            #     otp: 'OTP validation success',
            #   }],
            # }, status: :created
          else
            return render json: {
              errors: [{
                otp: 'Invalid OTP code',
              }],
            }, status: :unprocessable_entity
          end
          unless otp.activated?
            return render json: {
              errors: [{
                otp: 'OTP code not validated',
              }],
            }, status: :unprocessable_entity
          else
              account = BxBlockAccountBlock::Account.find(token.account_id)
  
              if account.update(:password => create_params[:new_password])
                otp.destroy
                serializer = BxBlockAccountBlock::AccountSerializer.new(account)
                serialized_account = serializer.serializable_hash
  
                render json: serialized_account, status: :created
              else
                render json: {
                  errors: [{
                    profile: 'Password change failed',
                  }],
                }, status: :unprocessable_entity
              end
            end
        else
          return render json: {
            errors: [{
              otp: 'Token and new password are required',
            }],
          }, status: :unprocessable_entity
        end
      end
  
      private
  
      def create_params
        params.require(:data)
          .permit(*[
            :email,
            :token,
            :otp_code,
            :new_password,
          ])
      end
end
