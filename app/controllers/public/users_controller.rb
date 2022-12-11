class Public::UsersController < ApplicationController
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

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

end
