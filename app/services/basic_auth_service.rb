# frozen_string_literal: true
class BasicAuthService < BaseService

  validates :resource, presence: { message: I18n.t('services.errors.invalid_cred') }

  with_options if: -> { resource.present? } do
    # validate :resource_must_be_active
    validate :password_must_be_valid
  end

  attr_reader :resource

  def initialize(resource, password)
    @resource = resource
    @password = password
  end

  def call
    @resource.update(auth_token: Devise.friendly_token) if valid?
    ServiceResult.new(self, data: @resource)
  end

  private

  # def resource_must_be_active
  #   errors.add(:resource, I18n.t('services.errors.deactivated')) if @resource.respond_to?(:is_archived?) && @resource.is_archived?
  # end

  def password_must_be_valid
    errors.add(:resource, I18n.t('services.errors.invalid_cred')) unless @resource.valid_password?(@password)
  end

end
