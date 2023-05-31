require "pry"
require "json"
require "net/http"
require_relative "pdf_document"

FORM_ID = 28
PAGE_SIZE = 50

offset = 0
total_count = nil

recipients = []
print "Downloading recipients..."

loop do
  uri = URI.parse("https://www.codewithjason.com/wp-json/gf/v2/entries")
  uri.query = URI.encode_www_form({
    'form_ids' => FORM_ID,
    'paging[offset]' => offset,
    'paging[page_size]' => PAGE_SIZE,
  })

  request = Net::HTTP::Get.new(uri)
  request.basic_auth(ENV["GF_CONSUMER_KEY"], ENV["GF_CONSUMER_SECRET"])

  response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
  end

  if !response.code.to_i == 200
    raise "HTTP Request failed (status code #{response.code})"
  end

  response_json = JSON.parse(response.body)
  total_count ||= response_json["total_count"]

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

pdf_document = PDFDocument.new(recipients)
pdf_document.render_file("labels.pdf")

puts "Done"
