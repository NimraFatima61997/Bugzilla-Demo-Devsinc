require 'test_helper'

class BugStatusControllerTest < ActionDispatch::IntegrationTest
  test "should get bug_status_options" do
    get bug_status_bug_status_options_url
    assert_response :success
  end

end
