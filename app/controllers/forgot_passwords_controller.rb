class ForgotPasswordsController < ApplicationController

  # We can delete the 'new' action here b/c we're not actually doing anything with it in the controller. Remember that the controller will automatically assume the need for a 'new' template.

  def create
    user = User.where(email: params[:email]).first
    if user
      AppMailer.delay.send_forgot_password(user) # Don't need 'deliver' b/c we're using the #delay method from Sidekiq.
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Email cannot be blank." : "There is no user in the system with that email addresss."
      redirect_to forgot_password_path
    end
  end

  # We can delete the 'confirm' action here b/c we'll only need to allow rails to render a static confirmation page that needs no instance variables, etc.

end
