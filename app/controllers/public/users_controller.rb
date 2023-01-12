class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :search

  def search
    @q = User.ransack(params[:q])
    # distinct: trueは重複したデータを除外
    @users = @q.result(distinct: true)
  end

  def index
   @users = User.where(user_status: '有効')
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
      # 画像が編集された場合
    if params[:user][:profile_image].present?
      # パラメーター(画像)を「tempfile」として開いて変数に代入
      profile_image = File.open(params[:user][:profile_image].tempfile)
      # Cloud Vision APIで画像分析して、分析結果を変数に代入
      result = Vision.image_analysis(profile_image)
    else
      # 画像が編集されてない場合は「true」を代入
      result = true
    end
    # 解析結果によって条件分岐
    if result == true
      @user.update(user_params)
      redirect_to user_path(@user), notice: "編集しました"
    elsif result == false
      flash[:notice] = '画像が不適切です'
      render 'edit'
    end
  end

  def quit
  end

  def withdraw
    @user = current_userpara
    @user.update(user_status: "自己退会")
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image, :prefecture_code, :user_status, :favorite_team)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
