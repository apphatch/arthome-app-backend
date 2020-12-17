class JsonWebToken
  class << self
    def encode payload
      payload[:exp] ||= 5.minutes.from_now
      JWT.encode(payload, Rails.application.credentials.config[:secret_key_base])
    end

    def decode token
      begin
        body = JWT.decode(token, Rails.application.credentials.config[:secret_key_base])[0]
        HashWithIndifferentAccess.new body
      rescue JWT::ExpiredSignature
        nil
      end
    end
  end
end
