require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..25
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => "name cannot contain special spaces or characters."

  validates_presence_of     :first_name
  validates_format_of       :first_name,     :with => Authentication.name_regex,  :message => "cannot contain special characters.", :allow_nil => true
  validates_length_of       :first_name,     :within => 2..60
  
  validates_presence_of     :last_name
  validates_format_of       :last_name,     :with => Authentication.name_regex,  :message => "cannot contain special characters.", :allow_nil => true
  validates_length_of       :last_name,     :within => 2..60

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  #validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => "address must be valid"

  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :first_name, :last_name, :password, :password_confirmation,
                  :remember_token, :remember_token_expires_at, :reset_password_token,
                  :display_name, :sortable_name, :location, :about_me, :blog_title,
                  :rating_average_skill, :rating_average_sportsmanship,
                  :photo, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at,
                  :private_decks, :public_decks

  has_many :posts
  has_many :comments
  has_many :decks
  
  ajaxful_rater
  ajaxful_rateable :stars => 5, :allow_update => true, :dimensions => ["skill", "sportsmanship"] 

  has_attached_file :photo, :styles => { :thumb=> ["32x32#", :jpg], :small  => ["96x96#", :jpg] }, :default_url => "/images/default_avatar.jpg"

  def generate_reset_password_token!(ip_address = nil)
    chars = ("a".."z").to_a + ("0".."9").to_a
    token = ""
    1.upto(30) { |i| token << chars[rand(chars.size-1)] }
    self.update_attributes(:reset_password_token => token)
    UserMailer.reset_password(self, token, ip_address).deliver
  end

  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    self.blog_title = self.login.capitalize + "'s Blog"
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def blog_posts
    Post.find(:all, :conditions => {:user_id => id, :post_type_id => 1})
  end
  
  def articles
    Post.find(:all, :conditions => {:user_id => id, :post_type_id => 2})
  end
  
  def decklists
    Post.find(:all, :conditions => {:user_id => id, :post_type_id => 3})
  end
  
  def tournament_reports
    Post.find(:all, :conditions => {:user_id => id, :post_type_id => 4})
  end
  
  def display_name
    "#{(self.first_name || "").capitalize} #{(self.last_name || "").capitalize}"
  end
  
  def sortable_name
    "#{(self.last_name || "").capitalize}, #{(self.first_name || "").capitalize}"
  end
  
  def last_blog_post
    self.blog_posts.last
  end
  
  def private_decks
    Deck.find(:all, :conditions => { :user_id => self.id, :shared => false })
  end
  
  def public_decks
    Deck.find(:all, :conditions => { :user_id => self.id, :shared => true })
  end

  protected
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end

end
