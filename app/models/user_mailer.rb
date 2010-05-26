class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://127.0.0.1:3000/activate/#{user.activation_code}"
    @body[:current_user] = user
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://127.0.0.1:3000"
    @body[:current_user] = user
  end
  
  def reset_password(user, reset_password_token, ip_address)
    setup_email(user)
    @subject += 'Request for password reset'
    @body[:url] = "http://www.swccgonline.com/reset_password/#{reset_password_token}"
    @body[:user] = user
    @body[:ip_address] = ip_address
end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "admin@swccgonline.com"
      @subject     = "swccgonline.com - "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
