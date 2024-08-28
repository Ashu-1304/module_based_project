module BxBlockProfile
 class Profile < ::ApplicationRecord
  self.table_name = :profiles
  belongs_to :account, class_name: 'BxBlockAccountBlock::Account'  
 end
end   