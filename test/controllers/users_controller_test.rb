require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "indexアクションのリダイレクトテスト" do
    get users_path 
    assert_redirected_to login_url
  end
  
  test "ログインしていないユーザーのdestroyはログイン画面にリダイレクト" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  test "ログインしていても別ユーザーのdestroyはトップページにリダイレクト" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  test "ユーザーのフォロー一覧ページを表示しようとするとログインページに飛ぶ" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end
  
  test "ユーザーのフォロワー一覧ページを表示しようとするとログインページに飛ぶ" do 
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
  
  

end
