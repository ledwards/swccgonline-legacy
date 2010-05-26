class UserObserver < ActiveRecord::Observer

  def after_create(user)
    UserMailer.deliver_signup_notification(user)
    user.logger.info('Sent activation code e-mail to #{user.email}')
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.recently_activated?
    user.logger.info('Sent final signup e-mail to #{user.email}')
  end
  
  def send_password_reset(user, new_password)
    UserMailer.deliver_password_reset(user, new_password)
    user.logger.info('Sent password reset e-mail to #{user.email}')
  end
end
