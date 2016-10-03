class Api::V1::User::SettingsController < Api::V1::User::BaseController
  before_action :find_setting, only: [:show, :update]

  def update
    if @setting.update update_setting_params
      render json: { success: true, data: SettingSerializer.new(@setting.reload) }, status: 200
    else
      render json: { success: false, error: @setting.errors.full_messages.last }, status: 422
    end
  end

  def show
    render json: SettingSerializer.new(@setting)
  end

  def find_setting
    @setting = current_user.setting
  end

  def update_setting_params
    params.require(:setting).permit(:friend_joins_chat, :notify_message_recieved, :notify_add_request)
  end
end
