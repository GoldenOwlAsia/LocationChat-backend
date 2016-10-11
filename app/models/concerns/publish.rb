module Publish
  extend ActiveSupport::Concern
  included do
    scope :in_friendship, ->(user_id, another_user_id) {
                              where('(from_user_id = :user_id AND to_user_id = :another_user_id ) OR (from_user_id = :another_user_id AND to_user_id = :user_id)', user_id: user_id, another_user_id: another_user_id) }
  end


end