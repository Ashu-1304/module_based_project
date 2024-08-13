require "test_helper"

class AddressesControllerTest < ActionDispatch::IntegrationTest
  test "should get fetch_location" do
    get addresses_fetch_location_url
    assert_response :success
  end
end
