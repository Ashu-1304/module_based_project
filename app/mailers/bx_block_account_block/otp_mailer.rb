module BxBlockAccountBlock
	class OtpMailer < ApplicationMailer
		default from: "sp8316886@gmail.com"
		def send_otp_email
		@otp = params[:otp]
		mail(to: params[:email], subject: 'Your OTP Code')
		end
	end
end