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
    context "with good save / valid input" do
      let(:charge) { double(:charge) } # This provides the doubled 'charge' that should be returned from the stubbed 'create' method below: StripeWrapper::Charge.should_receive(:create).and_return(charge)

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end
      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end
      it "redirects to the sign-in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
      it "makes the user follow the inviter" do # This (& the next 2 tests) tests that whenever a new user becomes a new user as a result of an invitation, he will automatically follow that inviter.
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, user_who_invites: alice, recipient_email: 'test@email.com')
        post :create, user: { email: 'test@email.com', password: 'password', full_name: 'Test Man' }, invitation_token: invitation.token
        test_man = User.where(email: 'test@email.com').first
        expect(test_man.follows?(alice)).to be_true
      end
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, user_who_invites: alice, recipient_email: 'test@email.com')
        post :create, user: { email: 'test@email.com', password: 'password', full_name: 'Test Man' }, invitation_token: invitation.token
        test_man = User.where(email: 'test@email.com').first
        expect(alice.follows?(test_man)).to be_true
      end
      it "expires the invitation upon acceptance" do # We want to make sure that the user can only accept the invitation once.
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, user_who_invites: alice, recipient_email: 'test@email.com')
        post :create, user: { email: 'test@email.com', password: 'password', full_name: 'Test Man' }, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil # We could also say, expect(invitation.reload.token)...
      end
    end
    context "with bad save / invalid input" do
      before do
        post :create, user: { password: "password", full_name: "name" }
      end
      it "does not create a user" do
        expect(User.count).to eq(0)
      end
      it "renders the new template" do
        expect(response).to render_template(:new)
      end
      it "sets the @user variable" do # We have to test for this b/c when we render the new template [in the controller], it is a sign-up form. For the 'new.html.haml' sign-up form to work, it should set the @user instance variable b/c 'new' is a model-based form and it needs this @user to be set in order for the form to render.
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
    context "sending emails" do

      after { ActionMailer::Base.deliveries.clear } # With most specs, the db will be rolled back to its initial state--but not with ActionMailer b/c we're sending out emails. When you run rspec, email sending is added to the ActionMailer::Base.deliveries queue; this is not part of the db transaction, so this will not be rolled back.  Doing this 'after' will cause the ActionMailer::Base.deliveries queue to be restored each time. After each spec runs, we'll clear the ActionMailer. 'after' means that the code within a block will run after each of the specs.

      it "sends out an email to the user with valid inputs" do
        StripeWrapper::Charge.should_receive(:create)
        post :create, user: { email: "john@test.com", password: "password", full_name: "John Smith" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@test.com"]) # the 'to' after 'last' should be an array b/c we can an email to multiple recipients.
      end
      it "sends out an email containing the user's name with valid inputs" do
        StripeWrapper::Charge.should_receive(:create)
        post :create, user: { email: "john@test.com", password: "password", full_name: "John Smith" }
        expect(ActionMailer::Base.deliveries.last.body).to include("John Smith")
      end
      it "does not send out email with invalid inputs" do
        post :create, user: { email: "john@test.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
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