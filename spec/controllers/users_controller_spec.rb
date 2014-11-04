require 'spec_helper'

describe UsersController do
  
  describe "GET new" do
    it "sets the @user instance variable" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    # before { User.first.destroy } # I wrote this here b/c for some reason it Fabricates an extra User object.  I don't yet know why.  In the UI, it works fine: It only creates one user when I create a user in the browser.
    # context "valid personal info and valid card" do
    context "successful user sign up" do
      it "redirects to the sign-in page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result) # We'll stub out the 'service object' b/c that is what the controller interacts with. The instance of 'UserSignup' has to receive the 'sign_up' message and then return a result.
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context "failed user sign up" do
      it "renders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result) # We'll stub out the 'service object' b/c that is what the controller interacts with. The instance of 'UserSignup' has to receive the 'sign_up' message and then return a result.
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231234' # It doesn't matter what our stripeToken is since we've stubbed it already; we're just using this info in this line to return a declined charge error.
        expect(response).to render_template :new
      end

      it "sets the flash danger message" do
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result) # We'll stub out the 'service object' b/c that is what the controller interacts with. The instance of 'UserSignup' has to receive the 'sign_up' message and then return a result.
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231234' # It doesn't matter what our stripeToken is since we've stubbed it already; we're just using this info in this line to return a declined charge error.
        expect(flash[:danger]).to eq("This is an error message") 
      end

      it "sets the @user variable" do # We have to test for this b/c when we render the new template [in the controller], it is a sign-up form. For the 'new.html.haml' sign-up form to work, it should set the @user instance variable b/c 'new' is a model-based form and it needs this @user to be set in order for the form to render.
        result = double(:sign_up_result, successful?: false, error_message: "This is an error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result) # We'll stub out the 'service object' b/c that is what the controller interacts with. The instance of 'UserSignup' has to receive the 'sign_up' message and then return a result.
        post :create, user: { password: "password", full_name: "name" }
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
  describe "GET show" do
    it_behaves_like "requires sign in" do # in spec/support/shared_examples.rb
      let(:action) { get :show, id: 3 } # We don't care what the id is here.
    end
    it "sets @user" do
      alice = Fabricate(:user)
      set_current_user(alice) # in spec/support/macros.rb ; NOTE: With this spec, we actually don't care who the current user is (we really don't need 'alice' & we can put the 'alice' variable-assignment below this line).
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the new view template" do
      invitation = Fabricate(:invitation) # This will generate a token.
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new # We want to render the :new view template rather than the default named template from this method.
    end
    it "sets @user with invitation recipient's email" do # We want the email address on the Register page to be pre-filled with the invitation recipient's email.
      invitation = Fabricate(:invitation) # This will generate a token.
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    it "sets @invitation_token" do # The users controller needs to set this for users/new.html/haml
      invitation = Fabricate(:invitation) # This will generate a token.
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: 'abcdefg'
      expect(response).to redirect_to expired_token_path
    end
  end
end