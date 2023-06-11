require "webmock/rspec"

require_relative "../recipient_list"

ENTRIES_ENDPOINT_URL = "https://www.codewithjason.com/wp-json/gf/v2/entries"

describe "consuming recipients from the WordPress API" do
  before do
    wordpress_response_body = {
      "entries" => [
        {
          "1" => "Jason Swett",
          "2" => "16601 Myers Lake Ave"
        }
      ],
      "total_count" => 1
    }

    stub_address_request(wordpress_response_body)
  end

  it "formats the response into a hash" do
    expect(recipients.first).to include(
      name: "Jason Swett",
      address: "16601 Myers Lake Ave"
    )
  end

  def stub_address_request(wordpress_response_body)
    stub_request(
      :get,
      "#{ENTRIES_ENDPOINT_URL}?form_ids=28&paging%5Boffset%5D=0&paging%5Bpage_size%5D=50"
    ).to_return(
      status: 200,
      body: wordpress_response_body.to_json.to_s,
      headers: {}
    )
  end
end
