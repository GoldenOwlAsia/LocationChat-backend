# frozen_string_literal: true
class TwilioAuthService < BaseService
  validates :device_token, presence: true
  validates :identity_name, presence: true
  attr_reader :device_token, :identity_name
  def initialize(user_id, device_token)
    @device_token = device_token
    @identity_name = user_id
  end

  def call
    validate
    token.add_grant grant
    token.to_jwt
  end

  private

  def end_point
    "#{Rails.application.secrets.twilio_app_name}:#{@identity_name}:#{@device_token}"
  end

  def token
    Twilio::Util::AccessToken.new Rails.application.secrets.twilio_account_sid,
      Rails.application.secrets.twilio_api_key, Rails.application.secrets.twilio_api_secret, 3600, @identity_name
  end

  def grant
    grant = Twilio::Util::AccessToken::IpMessagingGrant.new
    grant.service_sid = Rails.application.secrets.twilio_service_sid
    grant.endpoint_id = end_point
    grant
  end

  def token_validity
    errors.add(:identity_name, :invalid) unless @device_token.identity_name && ActiveSupport::SecurityUtils.secure_compare(@device_token.identity_name, @identity_name)
  end
end
