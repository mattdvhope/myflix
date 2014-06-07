class PasswordResetsController < ApplicationController
  def show # We're trying to show the 'Reset your Password' page here.  If the token is valid, we'll render the view template, but if it's not valid, then we'll redirect_to the '/invalid token' ('Your reset password link is expired') page.
    user = User.where(token: params[:id]).first
    redirect_to expired_token_path unless user # unless we can find a user
  end
end
