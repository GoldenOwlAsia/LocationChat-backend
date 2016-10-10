# == Schema Information
#
# Table name: channel_users
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  channel_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_favorite :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :channel_user do
    is_favorite { [true, false].sample }
    user
    channel
  end
end
