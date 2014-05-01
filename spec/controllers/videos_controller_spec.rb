require 'spec_helper'

describe VideosController do

  describe "GET show" do
    it "sets the @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    it "redirects user to the sign-in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do

    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: 'Bugs Bunny') # You can over-ride Fabricate like I did here with 'title'.
      get :search, search_term: "unn"
      expect(assigns(:results)).to eq([video])
    end
    it "redirect_to sign in page for unauthenticated users" do
      video = Fabricate(:video, title: 'Bugs Bunny') # You can over-ride Fabricate like I did here with 'title'.
      get :search, search_term: "unn"
      expect(response).to redirect_to sign_in_path
    end
  end
end