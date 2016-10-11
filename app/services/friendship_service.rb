class FriendshipService < BaseService
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true

  attr_accessor :from_user_id, :to_user_id

  def initialize(from_user_id, to_user_id)
    @from_user_id = from_user_id
    @to_user_id = to_user_id
  end

end