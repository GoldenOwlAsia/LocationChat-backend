# == Schema Information
#
# Table name: friendships
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  invited_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
