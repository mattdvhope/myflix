require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: ''
        expect(flash[:error]).to eq("Email cannot be blank.")
      end
    end
    context "with existing email" do
      it "redirects to the forgot password confirmation page" do
        Fabricate(:user, email: "joe@test.tv")
        post :create, email: "joe@test.tv"
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it "sends out an email to the email address" do
        Fabricate(:user, email: "joe@test.tv")
        post :create, email: "joe@test.tv"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@test.tv"])
      end
    end
    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: 'tom@test.tv'
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        post :create, email: 'tom@test.tv'
        expect(flash[:error]).to eq("There is no user in the system with that email addresss.")
      end
    end
  end
end
