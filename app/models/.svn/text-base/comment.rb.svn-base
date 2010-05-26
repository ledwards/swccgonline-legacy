class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  validates_presence_of :user_id, :post_id, :body
  
  def after_create
    post = Post.find(post_id)
    post.comments << self
  end
  
end
