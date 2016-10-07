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

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    provider 'facebook'
    uid { Faker::Number.number(10) }
    name { Faker::Name.name }
    device_token 'qwerty'
    password 'password'
    password_confirmation 'password'
    auth_token { Faker::Number.hexadecimal(10) }
    url_image_picture { Faker::Avatar.image }
    longitude { Faker::Address.latitude }
    latitude { Faker::Address.longitude }
  end

  trait :facebook do
    provider 'facebook'
  end
end
