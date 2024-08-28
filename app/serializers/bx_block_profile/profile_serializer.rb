module BxBlockProfile
  class ProfileSerializer < ActiveModel::Serializer
    attributes :id, :country, :address, :city, :postal_code, :account_id, :profile_role
    end
  end
  