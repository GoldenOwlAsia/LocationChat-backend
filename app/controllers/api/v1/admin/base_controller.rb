# frozen_string_literal: true
class Api::V1::Admin::BaseController < Api::V1::BaseController

  before_action :authenticate_user!

  def query_params
    filter_params
      .merge(sort_params)
      .merge(page_params)
  end

  private

  def current_user
    @current_resource
  end

  def authenticate_user!
    authenticate!(User)
  end

  def page_params
    { page: params.dig(:page, :number), per_page: params.dig(:page, :size) }
  end

  def sort_params
    params.permit(:sort)
  end

  def filter_params
    params.permit(:filter)
  end

end
