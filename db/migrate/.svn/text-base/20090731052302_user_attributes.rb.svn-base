class UserAttributes < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :location, :string
    add_column :users, :blog_title, :string
    add_column :users, :about_me, :text

    add_column :users, :photo_file_name, :string # Original filename
    add_column :users, :photo_content_type, :string # Mime type
    add_column :users, :photo_file_size, :integer # File size in bytes
    add_column :users, :photo_updated_at,   :datetime # Last file update time
    
    User.all.each do |u|
      u.first_name = u.name.split.first
      u.last_name = u.name.split.last
    end
    
    remove_column :users, :name
    
  end

  def self.down
    add_column :users, :name
    
    User.all.each do |u|
      u.name = u.first_name + " " + u.last_name
    end
    
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :location
    remove_column :users, :blog_title
    remove_column :users, :about_me
    
    remove_column :users, :photo_file_name
    remove_column :users, :photo_content_type
    remove_column :users, :photo_file_size
    remove_column :users, :photo_updated_at
    
  end
end
