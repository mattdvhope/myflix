require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      alice = Fabricate(:user) # First have to render a user (when we do this the 'before_create :generate_token' makes a token in 'user.rb')...
      alice.update_column(:token, '12345') #...then, we update_column with this new token ('12345') for this to be a valid test; for it to have the '12345' token rather than the token generated in 'user.rb'
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @token" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      it "redirects to the sign in page" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to sign_in_path
      end
      it "updates the user's password" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(alice.reload.authenticate('new_password')).to be_true # We have to reload alice b/c the post above will change the alice record underneath.
      end
      it "sets the flash success message" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(flash[:success]).to be_present
      end
      it "regenerates the user token" do # The prevents someone from optaining the user's token and then being able change the password anytime; we want this token to be short-lived.
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(alice.reload.token).not_to eq('12345')
      end
    end
    context "with invalid token" do # prevents someone from attacking the system
      it "redirects to the expired token path" do # No user is created here.
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
