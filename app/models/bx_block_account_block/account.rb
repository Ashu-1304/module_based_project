
module BxBlockAccountBlock
	class Account < ApplicationRecord
		self.table_name = :accounts
    has_secure_password
		validates :email,  presence: true
		validates :last_name, length: { minimum: 2, maximum: 30 }, format: { with: /\A[a-zA-Z\s]+\z/, message:"Your name cannot include special characters or numbers"}
		validates :first_name, length: { minimum: 2, maximum: 30 }, format: { with: /\A[a-zA-Z\s]+\z/, message:"Your name cannot include special characters or numbers"}
		validates :email, uniqueness: { case_sensitive: false, message:"This email address is already in use by another account"} 
		validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Invalid email address" }
		validate :password_format, on: :create
		validates :password, presence: true, on: :create
		validate :password_length_error_messages, on: :create

		private 
	
		def password_length_error_messages
		  if password.present? && password.length < 8
				errors.add(:password, 'Minimum character length is 8 characters')
		  elsif password.present? && password.length > 32
				errors.delete(:password)
				errors.add(:password, 'Maximum character length is 32 characters')
		  end
		end 

		def password_format
			return unless password.present? 
			unless password.match(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*\p{Punct}).*\z/)
			  errors.add(:password, 'Use a combination of uppercase and lowercase letters, numbers, and symbols')
			end
		end 
	end
end

