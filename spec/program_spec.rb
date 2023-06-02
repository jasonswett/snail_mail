require "webmock/rspec"

require_relative "../program"

ENTRIES_ENDPOINT_URL = "https://www.codewithjason.com/wp-json/gf/v2/entries"

describe "#consuming recipients" do
  before do
    response_body = {
      "entries" => [
        {
          "1" => "Jason Swett",
          "2" => "16601 Myers Lake Ave"
        }
      ],
      "total_count" => 1
    }

    stub_request(
      :get,
      "#{ENTRIES_ENDPOINT_URL}?form_ids=28&paging%5Boffset%5D=0&paging%5Bpage_size%5D=50"
    ).to_return(
      status: 200,
      body: response_body.to_json.to_s,
      headers: {}
    )
  end

  it "includes the recipient" do
    expect(recipients.first).to include(
      name: "Jason Swett",
      address: "16601 Myers Lake Ave"
    )
  end
end
