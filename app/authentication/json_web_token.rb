# frozen_string_literal: true
require 'httparty'
require 'uri'

class JsonWebToken
  @@next_fetch_time = DateTime.yesterday
  @@jwks_keys = nil

  def self.verify(token)
    JWT.decode(token, nil,
               true, # Verify the signature of this token
               algorithm: 'RS256',
               iss: ENV['AUTH_0_ISS'],
               verify_iss: true,
               aud: ENV['AUTH_0_AUD'],
               verify_aud: true) do |header|
      jwks_hash[header['kid']]
    end
  end

  def self.jwks_hash
    Hash[
        get.map do |k|
          [
              k['kid'],
              OpenSSL::X509::Certificate.new(
                  Base64.decode64(k['x5c'].first)
              ).public_key
          ]
        end
    ]
  end

  def self.get
    return @@jwks_keys if DateTime.now < @@next_fetch_time

    response = HTTParty.get URI("#{ENV['AUTH_0_ISS']}.well-known/jwks.json")

    fetch_date = DateTime.parse(response.headers['date'])

    max_age = response.headers['cache-control'].split[1].split('=')[1].to_i

    @@next_fetch_time = fetch_date + max_age.seconds

    @@jwks_keys = Array(JSON.parse(response.body)['keys'])
  end
end