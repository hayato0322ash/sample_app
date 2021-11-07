require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @micropost = microposts(:orange)
  end
  
  test "micropostをクリエイトしようとするとログインページに飛ぶかどうか？" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "micropostをデストロイしようとするとログインページに飛ぶかどうか？" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  
  test "違うユーザーのmicropostを削除しようとしたらリダイレクトするかどうか？" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
  
end
