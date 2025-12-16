class JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base

  # Encodes the payload (e.g., {user_id: 1}) into a JWT string
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    # The HMAC-SHA256 algorithm uses the application's secret key
    JWT.encode(payload, SECRET_KEY) 
  end

  # Decodes the JWT string back into the payload
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  rescue JWT::DecodeError => e
    # Returns nil on error (e.g., token expired, token invalid)
    nil 
  end
end