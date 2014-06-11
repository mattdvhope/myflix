class PasswordResetsController < ApplicationController
  def show # We're trying to show the 'Reset your Password' page here.  If the token is valid, we'll render the view template, but if it's not valid, then we'll redirect_to the '/invalid token' ('Your reset password link is expired') page.
    user = User.where(token: params[:id]).first # We need ':id' here b/c the token is coming from a resources path helper (the @user.token from views/app_mailer/send_forgot_password.html.haml). 'params' in this case is NOT 'user params'. They're just the params that we get when we open 'show.html.haml': {"id"=>"12345", "controller"=>"password_resets", "action"=>"show"}.  With resources 'show', whatever is passed into 'password_reset_url(@user.token)' is assigned to :id; it doesn't necessarily have to be an actual id; it's only whatever is passed into the parentheses of the 'show' path helper; in this case we have, password_reset_url(@user.token) ...which conveniently provides the token value (from views/app_mailer/send_forgot_password.html.haml).
    if user # if we can find a user
      @token = user.token # We're setting the token here for use in the 'hidden_field_tag' in 'show.html.haml'
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first # We DON'T need ':id' here b/c the token is NOT coming from a resources path helper.  Instead, token is the name of the element from the form that contains the token as its value (from the 'hidden_field-tag :token, @token' in 'show.html.haml').  Token is now available to us (it's already here), unlike at the start of the show method above which had needed the token to come from a resources path helper.
# binding.pry
    if user # we have a user b/c we have a valid token
      user.password = params[:password] # The user sets the new password.
      user.generate_token # Method from 'user.rb' ; This is where we 'regenerate the user token' for security purposes.
      user.save
      flash[:success] = "Your password has been changed. Please sign in"
      redirect_to sign_in_path
    else # "with invalid token" spec
      redirect_to expired_token_path
    end
  end

  # We don't need the 'expired_token' method here b/c rails will automatically go directly from 'routes.rb' to 'expired_token.html.haml'

end
