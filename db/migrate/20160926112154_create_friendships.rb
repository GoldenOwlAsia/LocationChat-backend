class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.datetime :invited_at

      t.timestamps null: false
    end
    add_index :friendships, :from_user_id
    add_index :friendships, :to_user_id
  end
end
