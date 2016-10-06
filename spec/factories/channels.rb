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
    place
  end

end
