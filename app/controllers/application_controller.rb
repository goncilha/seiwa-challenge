# frozen_string_literal: true

class ApplicationController < ActionController::API
  def authenticate
    jwt_token = request.headers["Authorization"]
    decoded_token = SeiwaAuth::Token.new.decode(jwt_token)
    user = User.find(decoded_token["user_id"])
    if user.nil? || user.disabled?
      render json: { error: "Usuário não encontrado ou desativado" }, status: :unauthorized
    end
  rescue Exception => e
    render json: { error: e.message }, status: :unauthorized
  end
end
