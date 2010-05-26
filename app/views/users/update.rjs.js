page.replace_html("settings_errors", :partial => "errors") if !@user.errors.empty?
page << "$('#settings_errors').corner();"
page.replace_html("settings_errors", "") if @user.errors.empty?
page << "$('.button').val('Save');"
page.replace_html("notice", flash[:notice])
