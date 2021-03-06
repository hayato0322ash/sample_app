class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit, :update]
  before_action :valid_user, only:[:edit, :update]
  before_action :check_expiration, only: [:edit, :update] 

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワードリセットのメールをご確認ください。"
      redirect_to root_url
    else
      flash.now[:danger] = "未登録のメールアドレスです。"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?                  # パスワードがブランク時の対応
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)          # 正常に入力されていた時の対応
      log_in @user
      flash[:success] = "パスワードをリセットしました"
      redirect_to @user
    else
      render 'edit'                                     # パスワードが照合できなかった時の対応
    end
  end
  
  private
    
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # beforeフィルタ
    
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # 期限切れかどうかを確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワード再設定の期限切れです。"
        redirect_to new_password_reset_url
      end
    end
end