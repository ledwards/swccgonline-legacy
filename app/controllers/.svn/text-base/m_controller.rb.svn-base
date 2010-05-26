class MController < ApplicationController
  skip_before_filter :authorize
  
  def welcome
    @user = User.find(params[:id]) || @current_user
    if @user.active?
      redirect_to "launch"
    end
  end
  
  def banned
    # log stuff
    @remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.env['REMOTE_ADDR'] || request.remote_addr || request.remote_ip
  end
  
  def denied
    # log stuff
    # use routes to capture requested url and display it to user
  end
  
  def error
    # use routes to capture requested url and display it to user
  end
  
  def missing
    # use routes to capture requested url and display it to user
  end
  
  def tos
    flash[:notice] = ""
  end
end
