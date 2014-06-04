require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    cartoons = Fabricate(:category) # category is needed b/c categories are on the home page (need home page for 'add_video_to_queue' method below...).
    bugs = Fabricate(:video, title: "Bugs Bunny", category: cartoons)
    road = Fabricate(:video, title: "Road Runner", category: cartoons)
    tom  = Fabricate(:video, title: "Tom & Jerry", category: cartoons)

    sign_in # in spec/support/macros.rb

    add_video_to_queue(bugs)
    expect_video_to_be_in_queue(bugs)

    visit video_path(bugs) # We're testing 'views/videos/show.html.haml'.
    expect_link_button_not_to_be_seen("+ My Queue") # We want the button, '+ My Queue' , to go away. We have to create a conditional in 'views/videos/show.html.haml' for this button (+ My Queue) so that it disappears if we have that video queued already.  We also need to write a #queued_video? method in 'user.rb' which we can then use in the conditional in 'views/videos/show.html.haml'.  Since we're writing this new method '#queued_video?' in user.rb, we have to write a test for it in 'user_spec.rb'.

    add_video_to_queue(road)
    add_video_to_queue(tom)

    # We'll use this 3 to uniquely identify video in My Queue rather than the two other choices (for the 3 videos) below.
    set_video_position(bugs, 3)
    set_video_position(road, 1)
    set_video_position(tom, 2)

    update_queue

    expect_video_position(bugs, 3)
    expect_video_position(road, 1)
    expect_video_position(tom, 2)
  end

  # Make sure these 6 methods are BELOW(outside of) the 'scenario'. The code above is pushed down to these methods.
  def add_video_to_queue(video)
    visit home_path
    click_on_video_on_home_page(video) # This method is in macros.rb
    click_link "+ My Queue"
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_button_not_to_be_seen(link_text)
    expect(page).to_not have_content link_text
  end

  def set_video_position(video, position) # Does NOT need a 'data' attribute in the 'text_field_tag' in 'views/queue_items/index.html.haml' b/c it's finding the video by looking for its title in the row.
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do # We'll refer to the whole row of the queue_item rather than referring to the List Order element (as we do w/ the other two choices). 'xpath' can be handy with complex select paths or queries, but it can also be hard to write. Double-slash ('//') means you're starting from anywhere in the html document where there is a 'tr' element (in this case).  The DOT before the comma means that 'under the tr' anywhere it 'contains' that string.
      fill_in "queue_items[][position]", with: position # This line DOES actually refer to the List Order Element directly below the table row cited in the line above.
    end
  end

  # Alternative set_video_position for identifying the 'text_field_tag' in 'views/queue_items/index.html.haml' and making a 'data' attribute to refer to (must un-comment it there).
  # def set_video_position(video, position)
  #   find("input[data-video-id='#{video.id}']").set(position)
  # end

  # Alternative set_video_position, BUT in 'views/queue_items/index.html.haml', we have to replace 'data: {video_id: queue_item.video.id}' with 'id: "video_#{queue_item.video.id}"' ; This is less preferable b/c we need access to the 'id' attribute (which in many cases will be unavailable since it's being used for CSS, JS, etc).  We do need some kind of a unique identifier though for the spec.
  # def set_video_position(video, position)
  #   fill_in "video_#{video.id}", with: position # In this test we have 3 videos, so we want to re-order all of these videos according to the number/integer we put next to each video here in the test.
  # end

  def update_queue
    click_button "Update Instant Queue"
  end

  def expect_video_position(video, position) # The second set of double-slashes ('//') anywhere under the 'tr', we look for an input element: attribute is 'input' and the type is 'text'.  Once we get that, we'll get 'value' out of it and then do our assertion.
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s) # When capybara reads from the screen, these numbers are strings, not integers.
  end
end