
require 'spec_helper'
require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  context "Associations" do
    it {should belong_to(:from_user).class_name('User')}
    it {should belong_to(:to_user).class_name('User')}
  end
end
