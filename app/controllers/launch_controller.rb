class LaunchController < ApplicationController

  def index
    @recent_posts = Post.n_most_recent(10, "all")
    @news = Post.find_all_by_user_and_post_type("admin", "blog post").last(5)
  end

end