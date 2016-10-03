class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :friend_joins_chat, default: true
      t.boolean :notify_message_recieved, default: true
      t.boolean :notify_add_request, default: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
