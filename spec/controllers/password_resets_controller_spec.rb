require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      alice = Fabricate(:user) # First have to render a user...
      alice.update_column(:token, '12345') #...then, we update_column with the token for this to be a valid test; for it to have an actual user object.
      get :show, id: '12345'
      expect(response).to render_template :show
    end
    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    
  end
end
