# frozen_string_literal: true

module SeiwaAuth
  class Base
    attr_accessor :jwt_secret, :expires_in

    def initialize
      @jwt_secret = Rails.env.test? ? "ee2b955aeed6a3e416a26005695bee2f5e19270c1b9a8703aa5bdfe899bd4869" : ENV["JWT_SECRET"]
      @expires_in = 1.day.from_now.to_i
    end
  end
end

