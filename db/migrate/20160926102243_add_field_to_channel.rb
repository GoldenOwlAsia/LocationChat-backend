class AddFieldToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :friendly_name, :string
  end
end
