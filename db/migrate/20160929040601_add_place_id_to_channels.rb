class AddPlaceIdToChannels < ActiveRecord::Migration
  def change
    add_reference :channels, :place, index: true, foreign_key: true
  end
end
