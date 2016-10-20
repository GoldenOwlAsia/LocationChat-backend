class AlertJob < ActiveJob::Base
  def perform(*data)
    @from_user = User.find data[0]
    @to_user = User.find data[1]
    @alert_msg = "#{@from_user.name}: #{data[2]}"
    APNS.send_notification(@to_user.device_token, alert: @alert_msg, other: { user_name: @from_user.name, url: @from_user.url_image_picture, id: @from_user.id, msg: data[2], sid: data[3] })
  end
end
