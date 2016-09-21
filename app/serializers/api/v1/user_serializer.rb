# frozen_string_literal: true
class Api::V1::UserSerializer < Api::V1::BaseSerializer

  attributes :id,
             :email,
             :name,
             :auth_token

end
