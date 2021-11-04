require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
    post users_path, params: { user: { name:  "",
                                     email: "user@gmail,com",
                                     password:              "h03220322",
                                     password_confirmation: "03220322" } }
    assert_template "users/new"
    end
  end
  
  test "valid signup information" do 
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path , params:{user: {name:"テストおじさん",email: "user@gmail.com",
                                     password:              "h03220322",
                                     password_confirmation: "h03220322" }}
    end
    follow_redirect!
    assert_template "users/show"
  end
end
