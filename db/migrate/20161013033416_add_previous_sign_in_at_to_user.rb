class AddPreviousSignInAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :previous_sign_in_at, :datetime
  end
end
