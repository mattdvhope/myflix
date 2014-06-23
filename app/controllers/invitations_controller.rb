class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge(inviter: current_user.full_name)) # .merge! is a ruby method that keeps all the current key-value pairs of the first hash and tacks on any other key value pairs that the second one has.  If any keys are the same, .merge! will keep the first hash's key-values.  Using only #merge will keep the SECOND hash's key value pairs when a key is the same between the two.
    @invitation.user_who_invites = current_user
    if @invitation.save
      AppMailer.delay.send_invitation_email(@invitation) # Don't need 'deliver' b/c we're using the #delay method from Sidekiq.
      flash[:success] = "You have successfully invited #{@invitation.recipient_name}."
      redirect_to new_invitation_path
    else
      flash[:error] = "Your inputs were invalid. Please try again."
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end

end
