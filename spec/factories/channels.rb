# == Schema Information
#
# Table name: channels
#
#  id                 :integer          not null, primary key
#  twilio_channel_sid :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  friendly_name      :string
#  place_id           :integer
#  public             :boolean
#

FactoryGirl.define do
  factory :channel do
    twilio_channel_sid { Faker::Number.number(10) }
    friendly_name { Faker::Address.street_name }
    
    transient do
      user {}
    end

    trait :direct do
      public false
      after(:create) do |channel, evaluator|
        create :channel_user, channel: channel, user: evaluator.user
      end
    end

    trait :directory do
      public true
      transient do
        latitude 10
        longitude 100
      end

      after(:create) do |channel, evaluator|
        channel.update place_id: create(:place, latitude: evaluator.latitude, longitude: evaluator.longitude).id
        create :channel_user, channel: channel, user: evaluator.user
      end
    end
  end
end
