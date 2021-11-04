require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = User.new(name:"河上勇人",email:"hayato.drsp@gmail.com",
    password:"h03220322", password_confirmation:"h03220322")
  end
  
  test "should be valid?" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@gmail.com"
    assert_not @user.valid?
    
  end
  
  test "email validation should accept valid addresses" do 
    valid_addresses = %w[hayato.drsp@gmail.com contact@starskill.jp hayato0322ash@yahoo.co.jp hayato0322biz@gmail.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?,"#{valid_address.inspect}should be valid "
    end
  end
  
  test "email validation should reject invalid addresses" do 
    invalid_addresses = %w[hayato.drsp@gmail,com contact_starskill.jp hayato0322ash@yahoo,co.jp hayato0322biz@gmail,com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?,"#{invalid_address.inspect}should be valid "
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid? 
  end
  
  test "password should be present (nonblank)" do 
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do 
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?
  end
  
end
