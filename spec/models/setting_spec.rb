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

require 'rails_helper'

RSpec.describe Setting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
