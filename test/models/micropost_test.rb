require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
      @user = users(:michael)
      @micropost = @user.microposts.build(content:"これはテストです")
  end
  
  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "micropostが空文字でないか？" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end
  
  test "micropostが140文字を超えていないか？" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "microposts_fixtureでmost_recentが一番最初であるテスト" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
