class AddPhotoUrlToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :photo_url, :string
  end
end
