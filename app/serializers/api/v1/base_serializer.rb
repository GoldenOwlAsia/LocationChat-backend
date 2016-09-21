# frozen_string_literal: true
class Api::V1::BaseSerializer < ActiveModel::Serializer

  attributes :created_at,
             :updated_at

end
