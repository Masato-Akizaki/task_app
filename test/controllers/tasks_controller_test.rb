require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get tasks_top_url
    assert_response :success
  end

end
