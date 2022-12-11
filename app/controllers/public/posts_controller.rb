class Public::PostsController < ApplicationController
   before_action :search
   
   
  def hashtag
    if params[:name].nil?
      @hashtags = Hashtag.all.to_a.group_by{ |hashtag| hashtag.posts.count}
    else
      name = params[:name]
      name = name.downcase
      @hashtag = Hashtag.find_by(hashname: name)
      @post = @hashtag.posts
      @hashtags = Hashtag.all.to_a.group_by{ |hashtag| hashtag.posts.count}
    end
  end
      

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿に成功しました"
      redirect_to posts_path
    else
      flash[:notice] = "投稿に失敗しました"
      render:new
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end
  
  def search
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
  end

  private

  def post_params
    params.require(:post).permit(:body, :hashbody)
  end

end
