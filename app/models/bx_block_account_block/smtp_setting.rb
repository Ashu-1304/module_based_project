module BxBlockAccountBlock
    class SmtpSetting < ApplicationRecord
        self.table_name = :smtp_settings
        validates :username,:smtp_password , presence: true, uniqueness:true
    end
end
