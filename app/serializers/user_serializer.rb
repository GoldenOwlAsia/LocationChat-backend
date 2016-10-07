# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  auth_token             :string
#  uid                    :string
#  device_token           :string
#  first_name             :string
#  last_name              :string
#  number_phone           :string
#  url_image_picture      :string
#  phone_country_code     :string
#  home_city              :string
#  provider               :string
#  location               :string
#  latitude               :string
#  longitude              :string
#

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
             :last_sign_in_at,
             :photos
  def photos
    object.photos.map(&:url)
  end
end
