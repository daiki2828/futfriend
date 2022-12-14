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
   @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end 
  
  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end 

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image, :prefacture_name)
  end
  
  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
