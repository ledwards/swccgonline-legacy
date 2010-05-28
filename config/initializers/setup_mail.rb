# config/initializers/setup_mail.rb
ActionMailer::Base.smtp_settings = {
  :address              => "mail.swccgonline.com",
  :port                 => 26,
  :domain               => "swccgonline.com",
  :user_name            => "admin+swccgonline.com",
  :password             => "secret",
  :authentication       => :login,
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "swccgonline.com"
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?