# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string
#  longitude  :float
#  latitude   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  photo_url  :string
#

class Place < ActiveRecord::Base
  has_one :channel, dependent: :destroy

  validates :name, uniqueness: true
end
