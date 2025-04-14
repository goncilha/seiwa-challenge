# frozen_string_literal: true

require "jwt"

module SeiwaAuth
  class Token < Base
    def initialize
      super
    end

    def encode(user_id)
      token = JWT.encode({ user_id: user_id, exp: @expires_in }, @jwt_secret, "HS256")
      { token: token, expires_in: @expires_in }
    end

    def decode(token)
      JWT.decode(token, @jwt_secret).first
    end
  end
end
