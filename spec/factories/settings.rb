# == Schema Information
#
# Table name: settings
#
#  id                      :integer          not null, primary key
#  friend_joins_chat       :boolean          default(TRUE)
#  notify_message_recieved :boolean          default(TRUE)
#  notify_add_request      :boolean          default(TRUE)
#  user_id                 :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

FactoryGirl.define do
  factory :setting do
    friend_joins_chat { [true, false].sample }
    notify_message_recieved { [true, false].sample }
    notify_add_request { [true, false].sample }
    user
  end
end
