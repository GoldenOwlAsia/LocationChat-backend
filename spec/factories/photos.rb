# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  url        :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :photo do
    url { Faker::Avatar.image }
    user nil
  end
end
