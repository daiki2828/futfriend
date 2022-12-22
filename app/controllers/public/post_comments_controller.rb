class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.new(parent_id: params[:parent_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id

    if comment.save
        #@post_comment.post.create_notification_post_comment!(current_user, @post_comment.id)
      respond_to :js
    else
      render 'public/posts/show'
    end

  end

  def destroy
    @post = Post.find(params[:post_id])
    PostComment.find_by(id: params[:id], post_id: params[:post_id]).destroy
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment, :parent_id)
  end

end
