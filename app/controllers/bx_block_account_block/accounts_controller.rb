module BxBlockAccountBlock
	class AccountsController < ApplicationController
		skip_before_action :verify_authenticity_token
		def create
      case params[:data][:type]
      when 'email_account'
        account_params = params.require(:data).require(:attributes).permit(:first_name, :last_name, :email, :password)
        query_email = account_params[:email]
        account = EmailAccount.where('LOWER(email) = ?', query_email).first
        user_account = BxBlockAccountBlock::Account.where(email: account_params[:email])
        if user_account.present? && user_account.pluck(:activated).include?(true)
          return render json: { errors: [{ account: 'The entered email-id is already registered. Please login' }] }, status: :unprocessable_entity
        end
        @account = EmailAccount.new(account_params)
        if @account.save
					otp_token = generate_otp
					valid_until = 5.minutes.from_now
						email_otp = EmailOtp.create!(
						email: @account.email,
						pin: otp_token,
						valid_until: valid_until
					)
					send_otp_email(@account.email, otp_token)
		      render json: BxBlockAccountBlock::EmailAccountSerializer.new(@account), status: :created
        else
          render json: { errors: @account.errors }, status: :unprocessable_entity
        end
      end
    end

		def verify_email_otp
			account = BxBlockAccountBlock::Account.find_by(email: params[:data][:attributes][:email])
			if account.present?
				if account.activated
					render json: { message: "Account is already activated" }, status: :unprocessable_entity
				else
					email_otp = EmailOtp.find_by(email: account.email)
					if email_otp&.pin == params[:data][:attributes][:otp].to_i && email_otp.valid_until > Time.current
						account.update(activated: true)
						notification = BxBlockNotifications::Notification.create(title: "Welcome Notification", message: "Welcome, #{account.first_name}! Your account has been successfully created.", account_id: account.id)
						if notification.save
							ActionCable.server.broadcast("notification_channel_#{account.id}", { notification: notification })
						end
						render json: { message: "OTP verified, account activated", user: account.as_json.merge(token: request.headers[:token]), notification:  notification }, status: :ok
					else
						render json: { message: "Invalid or expired OTP" }, status: :unprocessable_entity
					end
				end
			else
				render json: { message: "Account not found" }, status: :not_found
			end
		end

	  def resend_email_otp
			account = BxBlockAccountBlock::Account.find_by(email: params[:data][:attributes][:email])
			if account.present?
				otp_token = generate_otp
				valid_until = 5.minutes.from_now
				email_otp = EmailOtp.find_by(email: account.email)
				if email_otp.present?
					email_otp.update(pin: otp_token, valid_until: valid_until)
				else
					EmailOtp.create!(email: account.email, pin: otp_token, valid_until: valid_until)
				end
				send_otp_email(account.email, otp_token)
				render json: { message: 'OTP has been resent' }, status: :created
			else
				render json: { errors: [{ message: 'Account not found' }] }, status: :not_found
			end
	  end

		def index
			@account = BxBlockAccountBlock::Account.all 
			render json: BxBlockAccountBlock::AccountSerializer.new(@account), status: :ok
		end

		private
		def generate_otp
			rand(100000..999999)
		end
		
		def send_otp_email(email, otp_token)
			OtpMailer.with(email: email, otp: otp_token).send_otp_email.deliver_now
		end

	end
end
