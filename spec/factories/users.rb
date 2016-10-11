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
#  latitude               :float
#  longitude              :float
#

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    provider 'facebook'
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    uid { Faker::Number.number(10) }
    device_token 'qwerty'
    password 'password'
    password_confirmation 'password'
    auth_token { Faker::Number.hexadecimal(10) }
    url_image_picture { Faker::Avatar.image }
    longitude { 106.660172 }
    latitude { 10.762622 }
    factory :with_photos do
      transient do
        photos_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:photo, evaluator.photos_count, user: user)
      end
    end
  end

  trait :facebook do
    provider 'facebook'
  end
end
