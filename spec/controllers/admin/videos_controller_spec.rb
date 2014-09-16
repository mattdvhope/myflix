require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
    it "sets the @video to a new video" do
      set_current_admin # Not just 'set_current_user' here. 'set_current_admin' is in spec/support/macros.rb
      get :new
      expect(assigns(:video)).to be_instance_of Video # a NEW instance of Video
      expect(assigns(:video)).to be_new_record 
    end
    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end
    it "sets the flash error message for regular user" do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      it "redirects to the add new video page" do # redirected back to this page so that they can keep adding videos ; this is put first under "with valid input" in order to have the 'new' template rendered before anything else happens.
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: category.id, description: "Wonderful!" }
        expect(response).to redirect_to new_admin_video_path # Find this URL helper by looking at rake routes.
      end
      it "creates a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: category.id, description: "Wonderful!" }  # Because this is a model-backed form, everything will be hashed under the video hash-key.
        expect(category.videos.count).to eq(1)
      end
      it "sets the flash success message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: category.id, description: "Wonderful!" }  # Because this is a model-backed form, everything will be hashed under the video hash-key.
        expect(flash[:success]).to be_present
      end
    end
    context "with invalid input" do
      it "does not create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: category.id }  # This is an invalid input b/c there is no 'description', as required in the validation in video.rb
        expect(category.videos.count).to eq(0)
      end
      it "renders the :new template" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: category.id }  # This is an invalid input b/c there is no 'description', as required in the validation in video.rb
        expect(response).to render_template :new
      end
      it "sets the @video variable" do  # ...so that when we render the template, the instance variable is set so we can show the user's last input and all the error messages will be in this instance variable as well.
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: category.id }  # This is an invalid input b/c there is no 'description', as required in the validation in video.rb
        expect(assigns(:video)).to be_present # Testing that the instance variable ('@video', not 'video') is set, including in the flash[success] message.
      end
      it "sets the flash error message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: category.id }  # This is an invalid input b/c there is no 'description', as required in the validation in video.rb
        expect(flash[:error]).to be_present
      end
    end
  end
end
