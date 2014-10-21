class UsersController < ApplicationController

  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid? # We have to delay the creation of a user record until after the StripeWrapper::Charge is created, b/c we only want to create the user if the charge is successful, so we'll use the '#valid?' method rather than '#save' here. We can save after we've checked whether the charge was successful.
      # Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :card => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}"
      )
      if charge.successful? # In the use of our stubbing out of methods in our tests for this controller, we don't yet have to actually implement the "#successful?" method for 'stripe_wrapper.rb' -- for the purpose of testing. We 'drive out' the implementation of this method before we even define it (in stripe_wrapper.rb)
        @user.save
        handle_invitation
        flash[:success] = "Thanks for your payment."
        AppMailer.delay.send_welcome_email(@user) # Don't need 'deliver' b/c we're using the #delay method from Sidekiq.
        redirect_to sign_in_path
      else
        flash[:error] = charge.error_message # In the use of our stubbing out of methods in our tests for this controller, we don't yet have to actually implement the "#error_message" method for 'stripe_wrapper.rb' -- for the purpose of testing. We 'drive out' the implementation of this method before we even define it (in stripe_wrapper.rb)
        render :new
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password)
  end

  def handle_invitation
    if params[:invitation_token].present? # If true, then that means this user has been invited.
      invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(invitation.user_who_invites) # I need the 'follow' method here, so I'll have to write this method in 'user.rb'
      invitation.user_who_invites.follow(@user)
      invitation.update_column(:token, nil)
    end
  end

end