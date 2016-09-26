# == Schema Information
#
# Table name: channels
#
#  id                 :integer          not null, primary key
#  twilio_channel_sid :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  friendly_name      :string
#

require 'rails_helper'

RSpec.describe Channel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
