# frozen_string_literal: true
# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  url        :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PhotoSerializer < BaseSerializer
  attributes :id,
             :url
end
