class BxBlockAddressBlock::Address < ApplicationRecord
    self.table_name = "addresses"
    validates :place_name,uniqueness: true
end
