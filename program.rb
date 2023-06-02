require "pry"
require "json"
require "net/http"
require_relative "label_document"

FORM_ID = 28
PAGE_SIZE = 50

def uri(offset)
  uri = URI.parse("https://www.codewithjason.com/wp-json/gf/v2/entries")
  uri.query = URI.encode_www_form({
    'form_ids' => FORM_ID,
    'paging[offset]' => offset,
    'paging[page_size]' => PAGE_SIZE,
  })
  uri
end

def request(uri)
  request = Net::HTTP::Get.new(uri)
  request.basic_auth(ENV["GF_CONSUMER_KEY"], ENV["GF_CONSUMER_SECRET"])
  request
end

def response(uri, request)
  Net::HTTP.start(
    uri.hostname,
    uri.port,
    :use_ssl => uri.scheme == 'https'
  ) do |http|
    http.request(request)
  end
end

def run
  offset = 0
  recipients = []
  print "Downloading recipients..."

  loop do
    uri = uri(offset)
    request = request(uri)
    response = response(uri, request)

    if !response.code.to_i == 200
      raise "HTTP Request failed (status code #{response.code})"
    end

    response_json = JSON.parse(response.body)
    total_count = response_json["total_count"]

    recipients += response_json["entries"].map do |entry|
      {
        name: entry["1"],
        address: entry["2"]
      }
    end

    offset += PAGE_SIZE
    print "."
    break if offset >= total_count
  end

  puts
  puts "Rendering PDF..."

  label_document = LabelDocument.new(recipients)
  label_document.render_file("labels.pdf")

  puts "Done"
end

run
