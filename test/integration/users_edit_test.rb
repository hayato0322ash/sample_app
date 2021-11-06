require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "プロフィール情報の更新失敗テスト" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
  end
  
  test "プロフィール情報が正常に更新されるかのテスト" do 
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = "河上勇人"
    email = "hayato.drsp@gmail.com"
    patch user_path(@user), params:{user: {name: name ,
                                          email: email,
                                          password: "" ,
                                          password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
  test "editのbefore_actionが効いているかのテスト"  do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "updateのbefore_actionが効いているかのテスト" do
    patch user_path(@user), params:{ user:{name: @user.name, email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "違うユーザーが他人のプロフィールを確認できないようにするテスト" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "違うユーザーが他人のプロフィール更新をできないようにするテスト" do
    log_in_as(@other_user)
    patch user_path(@user), params:{user:{name: @user.name,email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "フレンドリーフォワーディングのテスト" do 
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "河上勇人"
    email = "hayato.drsp@gmail.com"
    patch user_path(@user), params:{user:{name: name, email: email,password: "", password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
  
end
