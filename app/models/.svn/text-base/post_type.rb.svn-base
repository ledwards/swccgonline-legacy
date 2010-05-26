class PostType < ActiveRecord::Base
  
  has_many :posts
  
  def self.options_for_select
    opt = {}
    PostType.all.each do |type|
      opt[type.name] = type.id
    end
    opt
  end
  
  def controller_name
    self.name.downcase.gsub(" ","_").pluralize
  end
  
  def singular_controller_name
    self.name.downcase.gsub(" ","_")
  end
  
end
