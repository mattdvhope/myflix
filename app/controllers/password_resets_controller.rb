class PasswordResetsController < ApplicationController
  def show # We're trying to show the 'Reset your Password' page here.  If the token is valid, we'll render the view template, but if it's not valid, then we'll redirect_to the '/invalid token' ('Your reset password link is expired') page.
    user = User.where(token: params[:id]).first
    if user # if we can find a user
      @token = user.token # We're setting the token here for use in the 'hidden_field_tag' in 'show.html.haml'
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user # we have a user b/c we have a valid token
      user.password = params[:password] # The user sets the new password.
      user.generate_token # Method from 'user.rb' ; This is where we 'regenerate the user token'
      user.save
      flash[:success] = "Your password has been changed. Please sign in"
      redirect_to sign_in_path
    else # "with invalid token" spec
      redirect_to expired_token_path
    end
  end

  # We don't need the 'expired_token' method here b/c rails will automatically go directly from 'routes.rb' to 'expired_token.html.haml'

end
