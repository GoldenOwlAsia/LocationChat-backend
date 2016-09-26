class Api::V1::User::TokensController < Api::V1::User::BaseController
  def create
    service = TwilioAuthService.new current_user.id, current_user.device_token
    if service.valid?
      render json: { success: true, data: { token: service.call } }
    else
      render json: { success: false, error: service.errors.full_messages.last }, status: 422
    end
  end
end
