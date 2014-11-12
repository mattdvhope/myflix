require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      # let(:charge) { double(:charge, successful?: true) } # This provides the doubled 'charge' that should be returned from the stubbed 'create' method below: StripeWrapper::Charge.should_receive(:create).and_return(charge)
      let(:customer) { double(:customer, successful?: true) }

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer) # Use of 'should_receive' REQUIRES the collaboration between our users_controller and our stripe_wrapper.
      end
      after do
        ActionMailer::Base.deliveries.clear # With most specs, the db will be rolled back to its initial state--but not with ActionMailer b/c we're sending out emails. When you run rspec, email sending is added to the ActionMailer::Base.deliveries queue; this is not part of the db transaction, so this will not be rolled back.  Doing this 'after' will cause the ActionMailer::Base.deliveries queue to be restored each time. After each spec runs, we'll clear the ActionMailer. 'after' means that the code within a block will run after each of the specs.
      end
      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil) # We've stubbed the StripeWrapper above, so it doesn't matter what we put in as the params for #sign_up ; In this test, we use 'build' rather than 'attributes_for', otherwise, we'll get, undefined method 'valid?' b/c we don't want to save it here.
        expect(User.count).to eq(1)
      end
      it "makes the user follow the inviter" do # This (& the next 2 tests) tests that whenever a new user becomes a new user as a result of an invitation, he will automatically follow that inviter.
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, user_who_invites: alice, recipient_email: 'test@email.com')
        UserSignup.new(Fabricate.build(:user, email: 'test@email.com', password: 'password', full_name: 'Test Man')).sign_up("some_stripe_token", invitation.token)
        test_man = User.where(email: 'test@email.com').first
        expect(test_man.follows?(alice)).to be_true
      end
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, user_who_invites: alice, recipient_email: 'test@email.com')
        UserSignup.new(Fabricate.build(:user, email: 'test@email.com', password: 'password', full_name: 'Test Man')).sign_up("some_stripe_token", invitation.token)
        test_man = User.where(email: 'test@email.com').first
        expect(alice.follows?(test_man)).to be_true
      end
      it "expires the invitation upon acceptance" do # We want to make sure that the user can only accept the invitation once.
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, user_who_invites: alice, recipient_email: 'test@email.com')
        UserSignup.new(Fabricate.build(:user, email: 'test@email.com', password: 'password', full_name: 'Test Man')).sign_up("some_stripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil # We could also say, expect(invitation.reload.token)...
      end
      it "sends out an email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'john@test.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@test.com"]) # the 'to' after 'last' should be an array b/c we can an email to multiple recipients.
      end
      it "sends out an email containing the user's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, full_name: "John Smith", email: 'john@test.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("John Smith")
      end
    end

    context "valid personal info and declined card" do # in 'users/new.html.haml', see comment under the Sign Up button about this needed test.
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.") # For this stubbed charge, we have to return ALL of the pertinant info, including error_message.
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('1223344', nil)
        expect(User.count).to eq(0)
      end
    end

    context "invalid personal info" do
      # before do
      #   post :create, user: { password: "password", full_name: "name" }
      # end

      after do
        ActionMailer::Base.deliveries.clear # With most specs, the db will be rolled back to its initial state--but not with ActionMailer b/c we're sending out emails. When you run rspec, email sending is added to the ActionMailer::Base.deliveries queue; this is not part of the db transaction, so this will not be rolled back.  Doing this 'after' will cause the ActionMailer::Base.deliveries queue to be restored each time. After each spec runs, we'll clear the ActionMailer. 'after' means that the code within a block will run after each of the specs.
      end

      it "does not create a user" do
        UserSignup.new(User.new(email: "matt@example.com")).sign_up('1223344', nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the credit card" do # Does not charge the card when the user provides invalid personal info. We should not call 'StripeWrapper::Charge.create' at all.
        UserSignup.new(User.new(email: "matt@example.com")).sign_up('1223344', nil)
        StripeWrapper::Customer.should_not_receive(:create) # We assert the StripeWrapper::Charge is not called
      end

      it "does not send out email with invalid inputs" do
        UserSignup.new(User.new(email: "matt@example.com")).sign_up('1223344', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end