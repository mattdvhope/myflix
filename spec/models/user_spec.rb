require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order('position') }
  it { should have_many(:reviews).order('created_at DESC') }

  it_behaves_like "tokenable" do # from 'support/shared_examples.rb'
    let(:object) { Fabricate(:user) }
  end

  describe "#queued_video?" do # We'll use this model method in 'queue_items_controller_spec.rb'
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_true
    end
    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be_false # 'false' b/c there is no :queue_item
    end
  end

  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).to be_true
    end
    it "returns false if the user does not have a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: bob)
      expect(alice.follows?(bob)).to be_false
    end
  end

  describe "#follow" do
    it "follows another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to be_true
    end

    it "does not follow one's self" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to be_false
    end
  end

  describe "deactivate!" do
    it "deactivates an active user" do
      alice = Fabricate(:user, active: true)
      alice.deactivate!
      expect(alice).not_to be_active
    end

    it "sends out an email to the user who has been deactivated" do
      alice = Fabricate(:user, active: true)
      alice.deactivate!
      expect(ActionMailer::Base.deliveries.last.to).to eq([alice.email]) # the 'to' after 'last' should be an array b/c we can an email to multiple recipients.
    end

    it "sends out an email containing the user's name with valid inputs" do
      alice = Fabricate(:user, active: true)
      alice.deactivate!
      expect(ActionMailer::Base.deliveries.last.body).to include(alice.full_name)
      expect(ActionMailer::Base.deliveries.last.subject).to include("Your MyFlix account has been suspended.")
    end
  end

  describe "activate!" do
    it "deactivates an active user" do
      alice = Fabricate(:user, active: false)
      alice.activate!
      expect(alice).to be_active
    end
  end
end