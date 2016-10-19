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
    token = generate_token
    update_service_settings
    token
  end

  private

  def update_service_settings
    # curl -X POST https://ip-messaging.twilio.com/v1/Services/ISe4aaa88ede714ca0b80a1507742b60a5 -d 'Notifications.NewMessage.Enabled=true' -d 'Notifications.NewMessage.Template=A New message in ${CHANNEL} from ${USER}: ${MESSAGE}' -u 'ACe645aed6cefa9bf1e08932bb9d7e93ba:6d6efec0e6878bf682d055f880319de4'
    uri = URI.parse("https://ip-messaging.twilio.com/v1/Services/#{Rails.application.secrets.twilio_service_sid}")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token)
    request.body = "ReadStatusEnabled=true&ReachabilityEnabled=true&Notifications.NewMessage.Enabled=true&Notifications.NewMessage.Template=A New message in ${CHANNEL} from ${USER}: ${MESSAGE}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    puts "successul service udpate"
    puts response.body

    # ip_messaging_client = Twilio::REST::IpMessagingClient.new(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token)
    # service = ip_messaging_client.services.get Rails.application.secrets.twilio_service_sid
    # service&.update read_status_enabled: true, reachability_enabled: true, notifications: { enabled: true }
    # binding.pry
  end

  def end_point
    "TwilioDemoApp:#{@identity_name}:browser"
  end

  def generate_token
    # Twilio::Util::AccessToken.new Rails.application.secrets.twilio_account_sid,
    #   Rails.application.secrets.twilio_api_key, Rails.application.secrets.twilio_api_secret, 3600, @identity_name
    token = Twilio::Util::AccessToken.new Rails.application.secrets.twilio_account_sid,
    Rails.application.secrets.twilio_api_key, Rails.application.secrets.twilio_api_secret, 36_000, @identity_name

    # Create IP Messaging grant for our token
    grant = Twilio::Util::AccessToken::IpMessagingGrant.new
    grant.service_sid = Rails.application.secrets.twilio_service_sid
    grant.endpoint_id = end_point
    token.add_grant grant
    token.to_jwt
  end

  def token_validity
    errors.add(:identity_name, :invalid) unless @device_token.identity_name && ActiveSupport::SecurityUtils.secure_compare(@device_token.identity_name, @identity_name)
  end
end
