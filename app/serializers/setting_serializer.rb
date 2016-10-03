class SettingSerializer < ActiveModel::Serializer
  attributes :friend_joins_chat,
             :notify_message_recieved,
             :notify_add_request
end
