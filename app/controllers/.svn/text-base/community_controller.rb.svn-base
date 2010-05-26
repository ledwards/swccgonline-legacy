class CommunityController < ApplicationController
  def index
    @top = {}
    @top[:blog_posts] = Post.top_n(5,"blog post")
    @top[:articles] = Post.top_n(5, "article")
    @top[:tournament_reports] = Post.top_n(5,"tournament report")
    @top[:decklists] = Post.top_n(5, "decklist")
    
    #@new_blog_posts = Post.n_most_recent(5,"blog post")
    #@new_articles = Post.n_most_recent(5, "article")
    #@new_tournament_reports = Post.n_most_recent(5,"tournament report")
    #@new_decklists = Post.n_most_recent(5, "decklist")
    
    @number_of_blog_posts = Post.blog_posts.length
    @number_of_articles = Post.articles.length
    @number_of_decklists = Post.decklists.length
    @number_of_tournament_reports = Post.tournament_reports.length
    @number_of_blogs = Post.number_of_blogs
  end
end
