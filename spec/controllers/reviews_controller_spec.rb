require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) } # We need this 'let' and 'before' to make this test ("creates a review associated with the signed in user") work.
      before { set_current_user(current_user) }
      context "with valid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end
        it "redirects to the video show page" do
          expect(response).to redirect_to video
        end
        it "creates a review" do
          expect(Review.count).to eq(1)
        end
        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(video)
        end
        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq(current_user)
        end
      end
      context "with invalid inputs" do
        # We did not use a 'before' here with the 'post' b/c on the 4th one, the 'review' object needs to be created first.
        it "does not create a review" do
          post :create, review: {rating: 4}, video_id: video.id
          expect(Review.count).to eq(0)
        end
        it "renders the videos/show template" do
          post :create, review: {rating: 4}, video_id: video.id
          expect(response).to render_template "videos/show"
        end
        it "sets @video" do
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end
        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end
    it_behaves_like "requires sign in" do
      let(:action) do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
      end
    end
  end
end
