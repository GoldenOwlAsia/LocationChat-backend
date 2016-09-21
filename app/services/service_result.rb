# frozen_string_literal: true
class ServiceResult

  extend ActiveModel::Naming
  extend ActiveModel::Translation

  attr_reader :data, :errors

  def initialize(*resources, data: nil)
    @data = data
    @errors = ActiveModel::Errors.new(self)
    resources.push(data).compact!
    resources.each do |resource|
      resource.errors.messages.each do |error_key, error_messages|
        error_messages.each { |error_message| @errors.add(error_key, error_message) }
      end
    end
  end

  def success?
    @errors.empty?
  end

  def fail?
    !success?
  end

end
