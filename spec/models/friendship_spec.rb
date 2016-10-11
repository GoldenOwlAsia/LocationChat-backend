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
require 'spec_helper'
require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context "Associations" do
    it {should belong_to(:from_user).class_name('User')}
    it {should belong_to(:to_user).class_name('User')}
  end
end
