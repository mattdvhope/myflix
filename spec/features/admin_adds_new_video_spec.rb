require 'spec_helper'

feature 'Admin adds new video' do
  scenario 'Admin successfully adds a new video' do
    admin = Fabricate(:admin)
    dramas = Fabricate(:category, name: "Dramas")
    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Monk"
    select "Dramas", from: "Category"
    fill_in "Description", with: "SF detective"
    save_and_open_page
    attach_file "Large cover", "/Users/matthewmalone/Sites/myflix/spec/support/uploads/monk_large.png"
    attach_file "Small cover", "/Users/matthewmalone/Sites/myflix/spec/support/uploads/monk.png"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"
    click_button "Add Video"

    sign_out # From spec/support/macros.rb -- You can sign in with or without a user.
    sign_in # From spec/support/macros.rb

    visit video_path(Video.first) # This is the show page for a selected video.
    expect(page).to have_selector("img[src='/uploads/video/large_cover/1/monk_large.png']")
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']") # the 'Watch Now' button
  end
end