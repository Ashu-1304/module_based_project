module BuilderJsonWebToken
  class JsonWebToken
    attr_reader :id, :expiration

    class << self
      def encode(id, data = {}, expiration = nil)
        if data.is_a?(Hash)
          expiration ||= 24.hours.from_now
        else
          expiration, data = data, {} # Default to an empty hash if data is not a Hash
        end

        payload = build_payload_for(id, data, expiration.to_i)

        JWT.encode(payload, secret_key, algorithm)
      end

      def decode(token)
        JsonWebToken.new(token_data_for(token))
      end

      private

      def token_data_for(token)
        JWT.decode(token, secret_key, true, {
          algorithm: algorithm,
        })[0]
      end

      def build_payload_for(id, data, expiration)
        {
          id: id,
          exp: expiration,
        }.merge(data)
      end

      def secret_key
        @secret_key ||= Rails.application.secret_key_base
      end

      def algorithm
        'HS512'
      end
    end

    def initialize(data)
      @id = data.delete('id')
      @expiration = Time.at(data.delete('exp')).to_time
      @struct = nil
      initialize_attributes_for(data) if data.is_a?(Hash) && data.keys.any?
    end

    private

    def initialize_attributes_for(data)
      @struct = Struct.new(*data.keys.map(&:to_sym)).new
      data.each do |key, value|
        @struct.send("#{key}=", value)
      end
    end

    def respond_to_missing?(method, *args)
      super || @struct.respond_to?(method)
    end

    def method_missing(method, *args, &block)
      return @struct.send(method) if @struct&.respond_to?(method)
      super
    end
  end
end
