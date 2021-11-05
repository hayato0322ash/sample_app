require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end
  
  test "ログイン失敗flashが一回のみでキチンと消えるか？" do
    get login_path
    assert_template "sessions/new"
    post login_path, params:{session:{email:"",password:""}}
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

end