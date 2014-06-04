require 'spec_helper'

feature 'User following' do
  scenario "user follows and unfollows someone" do

    alice = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: alice, video: video)

    sign_in
    click_on_video_on_home_page(video) # This method is in macros.rb ...This will bring us to the video show page which also has the links of the users under the reviews.

    click_link alice.full_name
    click_link "Follow" # This button link brings us to the people page.
    expect(page).to have_content(alice.full_name)

    unfollow(alice)
    expect(page).not_to have_content(alice.full_name)
  end

  def unfollow(user) # You can use this data-method='delete' b/c with this test, alice is the only person on this page; there are no other 'people' on this page.
    find("a[data-method='delete']").click # You can see this when you 'inspect element' on the browser.
  end
end