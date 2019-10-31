class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist

  validates_presence_of :email, allow_blank: false
  validates_uniqueness_of :email
end
