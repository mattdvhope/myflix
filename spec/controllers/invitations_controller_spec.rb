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
      it "sends an email to the recipient"
      it "sets the flash success message"
    end
    context "with invalid input"
  end
end
