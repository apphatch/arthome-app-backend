class JsonWebToken
 class << self
   def encode(payload, exp = 30.minutes.from_now)
     payload[:expires_at] = exp.to_i
     JWT.encode(payload, Rails.application.secrets.secret_key_base)
   end

   def decode(token)
     body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
     HashWithIndifferentAccess.new body
   rescue
     nil
   end
 end
end
