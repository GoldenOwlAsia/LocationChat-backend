# frozen_string_literal: true
class Api::V1::UserSerializer < Api::V1::BaseSerializer

  attributes :id,
             :email,
             :name,
             :auth_token,
             :device_token,
             :first_name,
             :last_name,
             :number_phone,
             :email,
             :url_image_picture,
             :phone_country_code,
             :home_city

end
