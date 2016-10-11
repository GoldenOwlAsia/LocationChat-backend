class ChangeColumnPublicInChannels < ActiveRecord::Migration
  def change
    change_column :channels, :public, :boolean, default: false
  end
end
