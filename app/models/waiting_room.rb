class WaitingRoom
  attr_reader :id, :name, :user_ids

  def initialize(id: nil, name:, user_ids:)
    raise BusinessError, 'Name required' if name.blank?
    raise BusinessError, 'The creator must join the room' if user_ids.empty?

    @id = id || SecureRandom.uuid
    @name = name
    @user_ids = user_ids
  end

  def join(user)
    raise BusinessError, "#{user.username} already in the waiting room" if @user_ids.include?(user.auth_id)
    raise BusinessError, "Room #{@name} is full" if full?

    @user_ids << user.auth_id

    UserJoinedWaitingRoom.new(@id, user.auth_id)
  end

  def full?
    @user_ids.count == Game::MAX_PLAYERS_IN_GAME
  end

  def can_start_game?
    @user_ids.count >= Game::MIN_PLAYERS_IN_GAME
  end
end