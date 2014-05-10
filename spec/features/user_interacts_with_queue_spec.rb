require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    cartoons = Fabricate(:category)
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

    # Two other options for setting video position below...

    # Instead of using the 'fill_in' lines below, we could use this for identifying the 'text_field_tag' in 'views/queue_items/index.html.haml'.
    # find("input[data-video-id='#{bugs.id}']").set(3)
    # find("input[data-video-id='#{road.id}']").set(1)
    # find("input[data-video-id='#{tom.id}']").set(2)

    # We can't use these 'fill_in' lines below b/c Capybara only works with id's.  We could also use 'data:' as an attribute identifier in 'views/queue_items/index.html.haml' as we did above.
    # fill_in "video_#{bugs.id}", with: 3 # In this test we have 3 videos, so we want to re-order all of these videos according to the number/integer we put next to each video here in the test.
    # fill_in "video_#{road.id}", with: 1
    # fill_in "video_#{tom.id}", with: 2

    update_queue

    expect_video_position(bugs, 3)
    expect_video_position(road, 1)
    expect_video_position(tom, 2)
  end

  # Make sure these 6 methods are BELOW(outside of) the 'scenario'. The code above is pushed down to these methods.
  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_button_not_to_be_seen(link_text)
    expect(page).to_not have_content link_text
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do # We'll refer to the whole row of the queue_item rather than referring to the List Order element (as we did below). 'xpath' can be handy with complex select paths or queries, but it can also be hard to write. Double-slash ('//') means you're starting from anywhere in the html document--anywhere there is a 'tr' (in this case).  The DOT before the comma means that 'under the tr', anywhere it 'contains' that string.  The second set of double-slashes ('//') anywhere under the 'tr', we look for an input element: attribute is 'input' and the type is 'text'.  Once we get that, we'll get 'value' out of it and then do our assertion.
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s) # When capybara reads from the screen, these numbers are strings, not integers.
  end
end