class AlertJob < ApplicationJob
  def perform(*data)
    @from_user = User.find data[0]
    @to_user = User.find data[1]
    @alert_msg = "#{@from_user.name}: #{data[2]}"

    if @to_user.device_token.present?
      APNS.send_notification(
        @to_user.device_token,
        alert: @alert_msg,
        sound: 'default',
        other: {
          from_user_id: @from_user.id,
          name: @from_user.name,
          sid: data[3]
        }
      )
    end
  end
end
