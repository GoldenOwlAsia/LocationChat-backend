class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :twilio_channel_sid

      t.timestamps null: false
    end
  end
end
