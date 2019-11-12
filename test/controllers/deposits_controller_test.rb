require 'test_helper'

class DepositsControllerTest < ActionDispatch::IntegrationTest
  test "should get deposit" do
    get deposits_deposit_url
    assert_response :success
  end

end
