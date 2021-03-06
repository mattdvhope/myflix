require 'spec_helper'

describe VideosController do

  describe "GET show" do
    it "sets the @video for authenticated users" do
      set_current_user
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    it "sets @reviews instance variable for authenticated users" do
      set_current_user
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
    it "redirects user to the sign-in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
    it "sets @video" do
    end
    it "sets @reviews" do
    end
  end

  describe "GET search" do

    it "sets @results for authenticated users" do
      set_current_user
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