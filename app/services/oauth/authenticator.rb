# frozen_string_literal: true
class Oauth::Authenticator

  class AuthFailure < StandardError; end
  class UnknownProvider < StandardError; end

  attr_reader :provider

  def initialize(params)
    @params = params
    @provider = @params[:provider].to_s
  end

  def call!
    case @provider
    when 'facebook'
      Oauth::FacebookAuthenticator.new(@params).call!
    else
      raise UnknownProvider, "Unknown provider: #{@params[:provider]}"
    end
  end

end
