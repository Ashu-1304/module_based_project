module BxBlockAccountBlock
  class EmailAccountSerializer 
    include FastJsonapi::ObjectSerializer
    attributes :id, :activated, :email, :first_name, :last_name
  end
end