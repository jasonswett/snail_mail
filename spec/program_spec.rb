require "webmock/rspec"

require_relative "../program"

ENTRIES_ENDPOINT_URL = "https://www.codewithjason.com/wp-json/gf/v2/entries"

describe "#run" do
  it "works" do
    response_body = {
      "entries" => [],
      "total_count" => 3
    }

    stub_request(
      :get,
      "#{ENTRIES_ENDPOINT_URL}?form_ids=28&paging%5Boffset%5D=0&paging%5Bpage_size%5D=50"
    ).to_return(
      status: 200,
      body: response_body.to_json.to_s,
      headers: {}
    )

    run_program
  end
end
