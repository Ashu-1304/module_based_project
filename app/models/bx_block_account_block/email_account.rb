module BxBlockAccountBlock
	class EmailAccount < Account
		validates :email, presence: true,format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
		message: "please enter valid email." }
	end
end
