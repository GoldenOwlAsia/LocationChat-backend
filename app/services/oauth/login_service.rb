# frozen_string_literal: true
class Oauth::LoginService < BaseService

  def initialize(authenticator, resource_klass, resource_params)
    @authenticator = authenticator
    @resource_klass = resource_klass
    @resource_params = resource_params
  end

  def call
    oauth_authenticate!
    link_or_create_resource!
    ServiceResult.new(data: @resource)
  rescue Oauth::Authenticator::AuthFailure, Oauth::Authenticator::UnknownProvider, ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    ServiceResult.new(self)
  end

  private

  def oauth_authenticate!
    @auth_user = @authenticator.call!
  end

  def link_or_create_resource!
    link_with_basic_auth_resource!
    find_or_create_oauth_resource!
  end

  def link_with_basic_auth_resource!
    basic_resource = @resource_klass.find_by(email: @auth_user.email, uid: nil, provider: nil)

    basic_resource.update!(uid: @auth_user.id, provider: @authenticator.provider) if basic_resource
  end

  def find_or_create_oauth_resource!
    @resource = @resource_klass.find_by(uid: @auth_user.id, provider: @authenticator.provider) || (@resource_params.presence && @resource_klass.new(@resource_params.merge(email: @auth_user.email, uid: @auth_user.id, provider: @authenticator.provider)))

    return unless @resource

    @resource.auth_token = Devise.friendly_token
    @resource.save!
  end

end
