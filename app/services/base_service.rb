# frozen_string_literal: true
class BaseService

  include ActiveModel::Model

  def last_error_message
    errors.full_messages.last
  end
end
