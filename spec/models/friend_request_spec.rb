# == Schema Information
#
# Table name: friend_requests
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  status       :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


require 'spec_helper'
require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  context "Associations" do
    it {should belong_to(:from_user).class_name('User')}
    it {should belong_to(:to_user).class_name('User')}
  end
end
