# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string
#  longitude  :float
#  latitude   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :place do
    name { Faker::Address.street_name }
    longitude { Faker::Address.latitude }
    latitude { Faker::Address.longitude }
  end
end
