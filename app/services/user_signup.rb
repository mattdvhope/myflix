class UserSignup  # This is a 'Service Object' that we have extracted from 'users_controller.rb'

  attr_reader :error_message # This provides access to the 'error_message' method when a charge is unsuccessful (below). '@error_message' is an instance variable of this class.

  def initialize(user) 
    @user = user # We need a user to be initialized here for use in the 'sign_up' method. This is an instance variable of this 'Service Object' itself.
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid? # We have to delay the creation of a user record until after the StripeWrapper::Charge is created, b/c we only want to create the user if the charge is successful, so we'll use the '#valid?' method rather than '#save' here. We can save after we've checked whether the charge was successful.
      # Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      customer = StripeWrapper::Customer.create(
        :user => @user,
        :card => stripe_token
      )
      if customer.successful? # In the use of our stubbing out of methods in our tests for this controller, we don't yet have to actually implement the "#successful?" method for 'stripe_wrapper.rb' -- for the purpose of testing. We 'drive out' the implementation of this method before we even define it (in stripe_wrapper.rb)
        @user.customer_token = customer.customer_token
        @user.save
        handle_invitation(invitation_token)
        AppMailer.delay.send_welcome_email(@user) # Don't need 'deliver' b/c we're using the #delay method from Sidekiq.
        @status = :success # For this execution path, the @status is set to :success ; We modify the internal state of this object on this line, then in the line below we return the object itself: "self"
        self # We return the 'self' (service object) here b/c we want its state so that users_controller.rb can query whether the sign_up 'result' is successful? (true) or not.
      else
        @status = :failed # We modify the internal state of this object on this line, then in the line below we return the object itself: "self"
        @error_message = customer.error_message # If the @status is failed, we also need to set the @error_message ; # In the use of our stubbing out of methods in our tests for the controller, we don't yet have to actually implement the "#error_message" method for 'stripe_wrapper.rb' -- for the purpose of testing. We 'drive out' the implementation of this method before we even define it (in stripe_wrapper.rb)
        self
      end
    else
      @status = :failed # We modify the internal state of this object on this line, then in the line below we return the object itself: "self"
      @error_message = "Invalid user information. Please check the errors below."
      self
    end
  end

  def successful? # This method will be used in 'users_controller.rb' to determine whether the 'result' (of the UserSignup) was successful.
    @status == :success
  end

  private

  def handle_invitation(invitation_token) # This method was moved from 'users_controller.rb' to be available for the 'sign_up' method above.
    if invitation_token.present? # If true, then that means this user has been invited.
      invitation = Invitation.where(token: invitation_token).first
      @user.follow(invitation.user_who_invites) # I need the 'follow' method here, so I'll have to write this method in 'user.rb'
      invitation.user_who_invites.follow(@user)
      invitation.update_column(:token, nil)
    end
  end

end