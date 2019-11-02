class User < ApplicationRecord
  validates_presence_of :email, allow_blank: false
  validates_uniqueness_of :email

  validates_presence_of :username, allow_blank: false
  validates_uniqueness_of :username

  alias_attribute :waiting_rooms, :user_waiting_rooms
  alias_attribute :games, :user_games

  has_many :user_waiting_rooms
  has_many :user_games
end
