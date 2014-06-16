require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "with valid input" do

      after { ActionMailer::Base.deliveries.clear } # Need this b/c in the "with valid input" context, these specs all send out emails, thus making the ActionMailer::Base filled with emails. Therefore, here, we have to clear out the ActionMailer::Base. With this, after each spec, the email queue will be cleared.

      it "redirects to the invitation new page" do # to invite a new user if desired
        set_current_user
        post :create, invitation: { recipient_name: "Tom Jones", recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        expect(response).to redirect_to new_invitation_path
      end
      it "creates an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Tom Jones", recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        expect(Invitation.count).to eq(1)
      end
      it "fills in the user_who_invites column with inviter/user" do
        inviter = Fabricate(:user)
        set_current_user(inviter)
        post :create, invitation: { recipient_name: "Tom Jones", recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        invitation = Invitation.first
        expect(invitation.user_who_invites).to eq(inviter)
      end
      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Tom Jones", recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['tom@test.tv'])
      end
      it "sets the flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "Tom Jones", recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        expect(flash[:success]).to be_present
      end
    end
    context "with invalid input" do # For 'invitations', we'll require all 3 fields to be present in invitation.rb
      it "renders the new template" do
        set_current_user
        post :create, invitation: { recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        expect(response).to render_template :new
      end
      it "does not create an invitation" do # We have the validations in 'invitation.rb', so this invitation won't be created.
        set_current_user
        post :create, invitation: { recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        expect(Invitation.count).to eq(0)
      end
      it "does not send out an email" do
        set_current_user
        post :create, invitation: { recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "sets the flash error message" do
        set_current_user
        post :create, invitation: { recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        expect(flash[:error]).to be_present
      end
      it "sets @invitation" do # Since it will render the 'new' template, we have to make sure we have @invitation instance variable set.
        set_current_user
        post :create, invitation: { recipient_email: "tom@test.tv", message: "Friend me at MyFlix." }
        expect(assigns(:invitation)).to be_present # Must change the 'invitation' local variable into @invitation.
      end
    end
  end
end
