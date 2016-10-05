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

require 'rails_helper'

RSpec.describe ChannelUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
