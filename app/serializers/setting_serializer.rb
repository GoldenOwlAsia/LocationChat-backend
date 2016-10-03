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

class SettingSerializer < ActiveModel::Serializer
  attributes :friend_joins_chat,
             :notify_message_recieved,
             :notify_add_request
end
