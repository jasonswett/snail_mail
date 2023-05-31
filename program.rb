require 'net/http'
require 'uri'
require 'json'
require "pry"

FORM_ID = 28
uri = URI.parse("https://www.codewithjason.com/wp-json/gf/v2/entries?form_ids=#{FORM_ID}")

request = Net::HTTP::Get.new(uri)
request.basic_auth(ENV["GF_CONSUMER_KEY"], ENV["GF_CONSUMER_SECRET"])

response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  http.request(request)
end

if !response.code.to_i == 200
  raise "HTTP Request failed (status code #{response.code})"
end

JSON.parse(response.body)["entries"].each do |entry|
  name = entry["1"]
  address = entry["2"]
  puts "-" * 20
  puts name
  puts address
end
