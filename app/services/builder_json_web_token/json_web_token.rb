require 'jwt'
module BuilderJsonWebToken
  class JsonWebToken
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
    ALGORITHM = 'HS512'
    
    def self.encode(payload, exp = 30.minutes.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
    
    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new(decoded)
    end

    def self.complex_encode(id, data = {}, expiration = nil)
      expiration, data = data, expiration unless data.is_a?(Hash)

      data       ||= {}
      expiration ||= 24.hours.from_now

      payload = build_payload_for(id.to_i, data, expiration.to_i)

      JWT.encode(payload, secret_key, ALGORITHM)
    end

    # Complex decoding method
    def self.complex_decode(token)
      data = token_data_for(token)
      JsonWebToken.new(data)
    end

    private


    def self.build_payload_for(id, data, expiration)
      { id: id, exp: expiration }.merge(data)
    end


    def self.token_data_for(token)
      JWT.decode(token, secret_key, true, {
        algorithm: ALGORITHM, 
      })[0]
    end
    def self.secret_key
      if ENV['SECRET_KEY_BASE'].nil?
        @secret_key = Rails.application.secrets.secret_key_base
      else
        @secret_key ||= ENV['SECRET_KEY_BASE']
      end
      return @secret_key
    end

    def algorithm
      'HS512'
    end

    def initialize(data)
      @id = data['id']
      @expiration = Time.at(data['exp']).to_time if data['exp']
      initialize_attributes_for(data)
    end

    def initialize_attributes_for(data)
      return unless data.is_a?(Hash) && data.keys.any?

      @struct = Struct.new(*data.keys.map(&:to_sym)).new
      data.each { |key, value| @struct.send("#{key}=", value) }
    end

    def respond_to_missing?(method, *args)
      super || @struct.respond_to?(method)
    end

    def method_missing(method, *args, &block)
      @struct.respond_to?(method) ? @struct.send(method) : super
    end
        
  end
end
