class CreatePostTypes < ActiveRecord::Migration
  def self.up
    create_table :post_types do |t|
      t.string :name

      t.timestamps
    end
  
    blog_post = PostType.create(:name => "Blog Post")
    article = PostType.create(:name => "Article")
    decklist = PostType.create(:name => "Decklist")
    tournament_report = PostType.create(:name => "Tournament Report")
  
  end

  def self.down
    drop_table :post_types
  end
end
