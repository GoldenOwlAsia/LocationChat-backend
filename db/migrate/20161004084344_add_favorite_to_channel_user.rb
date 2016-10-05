class AddFavoriteToChannelUser < ActiveRecord::Migration
  def change
    add_column :channel_users, :is_favorite, :boolean, default: false
  end
end
