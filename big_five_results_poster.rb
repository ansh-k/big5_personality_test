require_relative 'big_five_results_text_serializer'
require 'dry/monads/result'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

class BigFiveResultsPoster
  include Dry::Monads::Result::Mixin
  attr_reader :result_hash, :email, :url

  def initialize(result_hash = {}, email = nil)
    @result_hash = result_hash.merge!('EMAIL' => email)
    @url = "https://recruitbot.trikeapps.com/api/v1/roles/senior-team-lead/big_five_profile_submissions"
  end

  def post
    uri = URI.parse(@url)
    header = {'Content-Type': 'application/json'}

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri, header)
    req.body = @result_hash.to_json
    res = http.request(req)
    if (res.code == 201) || (res.code == 201)
      token = res&.token rescue ''
      Success(res.code, res&.token)
    else
      Failure(res.body)
    end
  end
end

result_hash = BigFiveResultsTextSerializer.new('Personality-Test-Center.txt').to_h
email = 'anshu92kumar2014@gmail.com'

big5 = BigFiveResultsPoster.new(result_hash, email)
puts big5.post
