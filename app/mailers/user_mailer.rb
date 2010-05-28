class UserMailer < ActionMailer::Base
  default :from => "admin@swccgonline.com"
  def signup_notification(user)
    mail(:to => "#{user.name} <#{user.email}>", :subject => 'Please activate your new account')
    @url  = "http://www.swccgonline.com/activate/#{user.activation_code}"
    @current_user = user
  end
  
  def activation(user)
    mail(:to => "#{user.name} <#{user.email}>", :subject => 'Your account has been activated!')
    @url  = "http://www.swccgonline.com"
    @current_user = user
  end
  
  def reset_password(user, reset_password_token, ip_address)
    mail(:to => "#{user.name} <#{user.email}>", :subject => 'Request for password reset')
    @url = "http://www.swccgonline.com/reset_password/#{reset_password_token}"
    @user = user
    @ip_address = ip_address
  end

end
