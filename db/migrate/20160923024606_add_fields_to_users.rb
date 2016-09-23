class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_id, :string
    add_column :users, :device_token, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :number_phone, :string
    add_column :users, :url_image_picture, :string
    add_column :users, :phone_country_code, :string
    add_column :users, :home_city, :string
  end
end
