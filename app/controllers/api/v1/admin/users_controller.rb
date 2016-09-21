# frozen_string_literal: true
class Api::V1::Admin::UsersController < Api::V1::Admin::BaseController

  def index
    users = User.all
    render_collection(users, meta: { total: users.count })
  end

  def show
    render_resource(find_user)
  end

  def create
    user = User.create(user_params)
    render_resource(user)
  end

  def update
    user = UpdateUserService.new(find_user, user_params).call
    render_resource(user.data)
  end

  # def activate
  #   user = find_user.tap { |d| d.update(is_archived: false) }
  #   render_resource(user)
  # end

  # def deactivate
  #   user = find_user.tap { |d| d.update(is_archived: true) }
  #   render_resource(user)
  # end

  private

  def filter_params
    params.permit(filter: [:status])
  end

  def find_user
    User.find(params[:id])
  end

  def user_params
    jsonapi_params(:email, :name, :password, :password_confirmation)
  end

end
