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

class Friendship < ActiveRecord::Base
  include Publish

end
