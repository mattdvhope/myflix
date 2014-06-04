def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id # assigns ‘.id’ to either one
end # The '||' allows the option of either having ‘alice’ or not having ‘alice’.

def sign_in(a_user=nil) # for the 'features specs'
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
  visit sign_out_path
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click # You can see this a[href]...etc by using 'inspect element' on a video icon on the home page.
end