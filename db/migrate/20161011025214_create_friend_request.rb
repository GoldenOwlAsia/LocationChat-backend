class CreateFriendRequest < ActiveRecord::Migration
  def change
    create_table :friend_requests do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :status, default: 0

      t.timestamps null: false
    end
    add_index :friend_requests, :from_user_id
    add_index :friend_requests, :to_user_id
  end
end
