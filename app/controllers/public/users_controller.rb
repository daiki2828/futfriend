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
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "編集しました"
    else
      render "edit"
    end
  end

  def quit
  end

  def withdraw
    @user = current_user
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
