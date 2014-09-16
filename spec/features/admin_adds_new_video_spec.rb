require 'spec_helper'

feature 'Admin adds new video' do
  scenario 'Admin successfully adds a new video' do
    admin = Fabricate(:admin)
    Fabricate(:category, name: "Dramas")
    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Monk"
    select "Dramas", from: "Category" # From the select box, "Category" on the browser. In this case, "Category" is a selector, which is why we say 'select' here for this feature test.
    fill_in "Description", with: "SF detective"
    # save_and_open_page # This will open a simple version of the page in my computer's default browser.
    attach_file "Large cover", "/Users/matthewmalone/Sites/myflix/spec/support/uploads/monk_large.png" # Don't forget the file suffix, which in this case is '.png'.  Make sure "Large cover" is spelled exactly correctly, including correct cases.
    attach_file "Small cover", "/Users/matthewmalone/Sites/myflix/spec/support/uploads/monk.png"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"
    click_button "Add Video"

    # Do this 'sign_out' & 'sign_in' to get out of the Admin's session and then to enter into an ordinary user's session to then see if the video that the admin had added is actually there on the video show page (tests below).
    sign_out # From spec/support/macros.rb -- You can sign in with or without a user.
    sign_in # From spec/support/macros.rb

    visit video_path(Video.first) # This is the show page for a selected video.  The 'Video.first' is the first video in the db--entered in above via the 'fill_in "Video URL"...etc'.
    expect(page).to have_selector("img[src='/uploads/video/large_cover/1/monk_large.png']") # the large cover / Find this correct 'src=' format by doing 'Inspect Element' on the large_cover on this page in the browser.
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']") # the 'Watch Now' button / the video URL
  end
end