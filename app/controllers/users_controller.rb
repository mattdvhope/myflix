class UsersController < ApplicationController

  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token]) # This is the 'Service Object' in 'app/services/user_signup.rb'. All the complex logic of the user signing up is in that 'Service Object'. We assign it to 'result' because we want to know (in 'app/services/user_signup.rb') whether its state--its return value--is :success or :failed
    if result.successful? # This 'successful?' method is in 'app/services/user_signup.rb'
      flash[:success] = "Thanks for your payment."
      redirect_to sign_in_path
    else
      flash[:danger] = result.error_message
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

end