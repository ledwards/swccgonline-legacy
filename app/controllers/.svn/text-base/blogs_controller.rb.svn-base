class BlogsController < ApplicationController
  
  def index
    @users = User.all
    @posts = Post.blog_posts
    @tags = Post.tag_counts #Note: this is NOT a real tag count for blog posts
  end
  
  def show
    @user = User.find_by_login(params[:login])
    @posts = Post.find_all_by_user_and_post_type(@user.login, "blog post").reverse
        
    respond_to do |format|
      format.html # by_login.html.erb
      format.xml  { render :xml => @posts }
    end
  end
end
