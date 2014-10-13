class UsersController < ApplicationController

  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      handle_invitation
      Stripe.api_key = ENV['STRIPE_SECRET_KEY'] # See 'config/application.yml'
      Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :card => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}"
      )
      AppMailer.delay.send_welcome_email(@user) # Don't need 'deliver' b/c we're using the #delay method from Sidekiq.
      redirect_to sign_in_path
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