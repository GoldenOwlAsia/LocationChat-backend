class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :friend_joins_chat, default: 1
      t.boolean :notify_message_recieved, default: 1
      t.boolean :notify_add_request, default: 1
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
