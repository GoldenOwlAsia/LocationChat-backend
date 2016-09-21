# frozen_string_literal: true
class TokenAuthService < BaseService

  validates :resource, presence: true
  validates :auth_token, presence: true
  validate :token_validity, if: -> { resource.present? && auth_token.present? }

  attr_reader :resource, :auth_token

  def initialize(resource, auth_token)
    @resource = resource
    @auth_token = auth_token
  end

  def call
    validate
    ServiceResult.new(self, data: @resource)
  end

  private

  def token_validity
    errors.add(:auth_token, :invalid) unless @resource.auth_token && ActiveSupport::SecurityUtils.secure_compare(@resource.auth_token, @auth_token)
  end

end
