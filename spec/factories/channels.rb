# == Schema Information
#
# Table name: channels
#
#  id                 :integer          not null, primary key
#  twilio_channel_sid :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  friendly_name      :string
#

FactoryGirl.define do
  factory :channel do
    twilio_channel_sid "MyString"
    friendly_name { Faker::Address.street_name }
  end

end
