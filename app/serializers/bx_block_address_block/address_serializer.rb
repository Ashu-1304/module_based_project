class BxBlockAddressBlock::AddressSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  attributes :place_name,:state,:longitude,:latitude
end
