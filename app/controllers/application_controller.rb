class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  before_filter :authorize
  session :session_key => '_swccgonline_session_id'
  helper :all # include all helpers, all the time
  protect_from_forgery
  layout 'application'
  
  @blog_post_id = 1
  
  private
  
  def authorize
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    else
      flash[:notice] = "Please log in"
      redirect_to(:controller => "login")
    end
  end
end
