require "webmock/rspec"

require_relative "../recipient_list"

describe RecipientList do
  describe "consuming recipient form entries from the WordPress API" do
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

      stub_wordpress_request(
        url: "https://www.codewithjason.com/wp-json/gf/v2/entries",
        response: wordpress_response_body
      )

      @recipient_list = RecipientList.new
    end

    it "formats the response into a hash" do
      expect(@recipient_list.items.first).to include(
        name: "Jason Swett",
        address: "16601 Myers Lake Ave"
      )
    end

    def stub_wordpress_request(url:, response:)
      stub_request(
        :get,
        "#{url}?form_ids=28&paging%5Boffset%5D=0&paging%5Bpage_size%5D=50"
      ).to_return(
        status: 200,
        body: response.to_json.to_s,
        headers: {}
      )
    end
  end
end
