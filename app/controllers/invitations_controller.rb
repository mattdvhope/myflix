class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
binding.pry
    @invitation = Invitation.create(invitation_params.merge!(inviter: current_user.id))
    redirect_to new_invitation_path  # .merge! is a ruby method that keeps all the current key-value pairs of the first hash and tacks on any other key value pairs that the second one has.  If any keys are the same, .merge! will keep the first hash's key-values (using only #merge will keep the SECOND hash's key value pairs when a key is the same between the two).
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end

end
