module BxBlockForgotPassword
    class OtpsController < ApplicationController
        skip_before_action :authenticate_request
        def create
            # puts " - params = #{params}"
            # json_params = jsonapi_deserialize(params)
            if params[:email].present?
              account = BxBlockAccountBlock::EmailAccount
                .where(
                  "LOWER(email) = ? AND activated = ?",
                  params['email'].downcase,
                  true
                ).first
              return render json: {
                errors: [{
                  otp: 'Account not found',
                }],
              }, status: :not_found if account.nil?
                

                otp_token = generate_otp
				valid_until = 5.minutes.from_now
				email_otp = BxBlockAccountBlock::EmailOtp.new(
					email: account.email,
					pin: otp_token,
					valid_until: valid_until
				)
                
              if email_otp.save
                send_email_for(account.email, email_otp)
                
                render json: serialized_email_otp(email_otp, account.id),
                  status: :created
              else
                render json: {
                  errors: [email_otp.errors],
                }, status: :unprocessable_entity
              end
            else
              return render json: {
                errors: [{
                  otp: 'Email required',
                }],
              }, status: :unprocessable_entity
            end
        end
        private
        def generate_otp
            rand(1000..9999)
        end
      
        def send_email_for(email, otp_record)
          BxBlockAccountBlock::OtpMailer.with(email: email, otp: otp_record.pin).send_otp_email.deliver_now
        end
    
        def serialized_email_otp(email_otp, account_id)
          token = token_for(email_otp, account_id)
          EmailOtpSerializer.new(
            email_otp,
            meta: { token: token }
          ).serializable_hash
        end
    
        def token_for(otp_record, account_id)
            BuilderJsonWebToken::JsonWebToken.complex_encode(
            otp_record.id,
            5.minutes.from_now,
            type: otp_record.class,
            account_id: account_id
          )
        end
    end
end
