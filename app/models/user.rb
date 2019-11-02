class User < ApplicationRecord
  validates_presence_of :email, allow_blank: false
  validates_uniqueness_of :email

  validates_presence_of :username, allow_blank: false
  validates_uniqueness_of :username
end
