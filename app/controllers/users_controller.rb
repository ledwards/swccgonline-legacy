class UsersController < ApplicationController
  skip_before_filter :authorize, :except => ["profile", "show", "index", "update", "change_settings_panel", "settings"]
  
  layout :choose_layout
  
  def new
    respond_to do |format|
      format.html { redirect_to :controller => "login" }
      format.js { @user = User.new }
    end
  end
  
  def index
    @users = User.all
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = "Thanks for joining, #{@user.login.capitalize}"
      respond_to { |format| format.js }
    else
      flash[:notice] = "Could not create account."
      respond_to { |format| format.js }
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Your account is activated. Please login."
      redirect_to :controller => "login"
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to :controller => "launch"
    end
  end
  
  def show
    @user = User.find_by_login(params[:id]) || User.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def settings
    @user = @current_user
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def update
    @user = @current_user
    
    respond_to do |format|
      format.js {
        if @user.update_attributes(params[:user])
          flash[:notice] = 'Account was successfully updated.'
        else
          flash[:notice] = 'There were errors with the account.'
        end
      }
      
      format.html { 
        if @user.update_attributes(params[:user])
          flash[:notice] = 'Account was successfully updated.'
          redirect_to "/settings"
        else
          flash[:notice] = 'There were errors with the account.'
          redirect_to "/settings"
        end
      }
    end
  end
  
  def resend_activation_code
    @user = User.find(params[:id])
    if !@user.active?
      UserMailer.deliver_signup_notification(@user)
      flash[:notice] = "Notification sent."
    else
      flash[:notice] = "Account already active."
    end
    redirect_to :controller => "m", :action => "welcome", :id => @user.id
  end
  
  def send_reset_password
    respond_to do |format|
      format.js {
        if @user = User.find_by_email(params[:email])
          @ip_address = request.env["HTTP_X_FORWARDED_FOR"] || request.env['REMOTE_ADDR'] || request.remote_addr || request.remote_ip
          @user.generate_reset_password_token!(@ip_address)
          flash[:notice] = 'Please check your e-mail to confirm password reset.'
          redirect_to :controller => "login"
        else
          flash[:error] = '#{params[:email]} is not in use by any SWCCG Online member. Please try again.'
        end
      }
    end
  end
  
  def reset_password
    @reset_password_token = params[:reset_password_token]
    @current_user = User.find_by_reset_password_token(@reset_password_token)
    @user = @current_user || User.new

    if @current_user.nil? || @reset_password_token.nil?
      @reset_password_token = ""
      redirect_to :controller => "m", :action => "denied"
    end
  end
  
  def set_password
    @reset_password_token = params[:reset_password_token]
    @user = User.find_by_reset_password_token(@reset_password_token)
    respond_to do |format|
      format.html { 
        if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
          @user.update_attributes(:reset_password_token => nil)
          flash[:notice] = 'Password successfully changed. Please log in.'
          redirect_to "/login"
        else
          flash[:errors] = 'Passwords do not match.'
          redirect_to "/reset_password/#{params[:reset_password_token]}"
        end
      }
    end
  end
  
  def rate
    @user = User.find(params[:id])
    @user.rate(params[:stars], current_user, params[:dimension])
    id = "ajaxful-rating-post-#{@post.id}"
    render :update do |page|
      page.replace_html id, ratings_for(@user, :wrap => false, :dimension => params[:dimension])
      page.visual_effect :highlight, id
    end
  end
  
  def change_settings_panel
    @user = @current_user
    @settings_panel = params[:settings_panel]

    respond_to do |format|
      format.js
    end
  end
  
  private
  def choose_layout    
    if [ 'reset_password' ].include? action_name
      'sessions'
    elsif ['new'].include? action_name
      nil
    else
      'users'
    end
  end
  
end
