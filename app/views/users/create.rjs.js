page.replace_html("signup_errors", :partial => "errors") if !@user.errors.empty?
page.redirect_to(:controller => "m", :action => "welcome", :id => @user.id) if @user.errors.empty?