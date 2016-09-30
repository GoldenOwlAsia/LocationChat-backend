FactoryGirl.define do
  factory :setting do
    friend_joins_chat false
    notify_message_recieved false
    notify_add_request false
    user nil
  end
end
