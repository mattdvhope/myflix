require 'spec_helper'

describe UsersController do
  
  describe "GET new" do
    it "sets the @user instance variable" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with good save / valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end                          # .attributes_for(:user) does NOT save to the DB.
      it "creates the user" do
        # user = Fabricate(:user)
        expect(User.count).to eq(1)
      end
      it "redirects to the sign-in page" do
        expect(response).to redirect_to sign_in_path
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
  end
end