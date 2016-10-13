# frozen_string_literal: true
class Oauth::FacebookAuthenticator < Oauth::Authenticator

  def initialize(auth_params)
    @auth_params = auth_params
  end

  def call!
    user = User.find_by provider: :facebook, uid: @auth_params[:uid]
    OpenStruct.new id: user.uid, email: user.email, provider: :facebook
  rescue Exception => e
    raise Oauth::Authenticator::AuthFailure, e.message
  end

end
