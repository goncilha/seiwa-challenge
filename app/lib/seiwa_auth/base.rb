# frozen_string_literal: true

module SeiwaAuth
  class Base
    attr_accessor :jwt_secret, :expires_in

    def initialize
      @jwt_secret = ENV["JWT_SECRET"]
      @expires_in = 1.day.from_now.to_i
    end
  end
end
