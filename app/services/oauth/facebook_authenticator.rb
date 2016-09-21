# frozen_string_literal: true
class Oauth::FacebookAuthenticator < Oauth::Authenticator

  def initialize(auth_params)
    @auth_params = auth_params
  end

  def call!
    auth = FbGraph2::User.new(@auth_params[:uid]).authenticate(@auth_params[:oauth_token])
    auth.fetch(fields: [:name, :id, :email])
  rescue FbGraph2::Exception => e
    raise Oauth::Authenticator::AuthFailure, e.messages
  end

end
