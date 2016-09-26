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
  belongs_to :from_user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :to_user, class_name: 'User', foreign_key: 'to_user_id'

  validates_uniqueness_of :to_user_id, scope: [:from_user_id], message: 'already existed'
end
