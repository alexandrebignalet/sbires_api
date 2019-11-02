require 'httparty'
require 'uri'

class FindOrCreateUser
  def self.call(token)
    ActiveRecord::Base.transaction do
      decoded_token = JsonWebToken.verify(token)

      user_auth_id =  decoded_token.first["sub"]

      maybe_user = User.find_by(auth_id: user_auth_id)
      return maybe_user if maybe_user.present?

      create_user(token)
    end
  end

  def self.create_user(token)
    user_info = user_info(token)

    User.create!(username: user_info["nickname"],
                 email: user_info["email"],
                 auth_id: user_info["sub"])
  end


  def self.user_info(token)
    url = URI("#{ENV['AUTH_0_ISS']}userinfo")

    headers = { Authorization: "Bearer #{token}" }

    res = HTTParty.get(url, headers: headers)

    JSON.parse(res.body)
  end
end