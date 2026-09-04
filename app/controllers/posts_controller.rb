class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @posts = Post.recent.includes(:user)
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "Το post δημιουργήθηκε"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Το post ενημερώθηκε"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Το post διαγράφηκε"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_owner!
    redirect_to posts_path, alert: "Δεν έχεις δικαίωμα" unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end