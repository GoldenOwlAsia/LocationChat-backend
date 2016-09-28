# frozen_string_literal: true
class UserSerializer < BaseSerializer

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
             :home_city,
             :location,
             :longitude,
             :latitude,
             :photos

  def photos
    object.photos.map(&:url)
  end
end
