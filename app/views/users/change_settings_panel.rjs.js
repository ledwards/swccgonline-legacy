page.replace_html("settings_content", :partial => @settings_panel)
page.replace_html("settings_errors", "") if @user.errors.empty?