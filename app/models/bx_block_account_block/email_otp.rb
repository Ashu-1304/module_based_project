module BxBlockAccountBlock
	class EmailOtp < ApplicationRecord
		self.table_name = :email_otps
		validates :email, presence: true
	end
end

