require 'spec_helper'

feature 'User invites a friend' do
  scenario 'User successfully invites friend and invitation is accepted', { js: true, vcr: true } do # Be sure to have the correct Capybara.server_port (i.e., 52622) in 'spec_helper.rb' and 'test.rb'
    alice = Fabricate(:user)
    sign_in(alice)

    invite_a_friend # See this method below the scenario we're in now.
    friend_accepts_invitation
# binding.pry # In 'binding.pry' we can type 'save_and_open_page' to look at which page we're actually going to.
    friend_signs_in
    friend_should_follow_inviter(alice)
    inviter_should_follow_friend(alice)

    clear_email # We don't want the email in this test to leak out to other tests.
  end

  def invite_a_friend
    visit new_invitation_path # This will bring us to the '/invitations/new' page.
    fill_in "Friend's Name", with: "Tom Smith"
    fill_in "Friend's Email Address", with: "tom@example.tv"
    fill_in "Text Message", with: "Please join MyFlix."
    click_button "Send Invitation"
    sign_out # Signing out here ensures that we'll start a new session for the invitee (& not be in the session of the inviter). From macros.rb
  end

  def friend_accepts_invitation
    # StripeWrapper::Charge.should_receive(:create)
    open_email "tom@example.tv" # We're using the capybara-email gem here.
    current_email.click_link "Accept this invitation" # This will take us to the Register page with the email field already pre-filled.
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Tom Smith"
    fill_in "Credit Card Number", with: "4242424242424242"   # After we set up the Credit card part of the sign up form, we have to put in this line (and subsequent lines pertaining to the Credit Card sign up).
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month" # The 'date_month' syntax comes from the id when you select this form element in the browser.
    select "2018", from: "date_year"      # The 'date_year' syntax comes from the id when you select this form element in the browser.
    click_button "Sign Up" # This will take us to the sign_in page.
  end

  def friend_signs_in
    fill_in "Email Address", with: "tom@example.tv"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  def friend_should_follow_inviter(inviter)
    click_link "People" # After the invitee signs in, he/she can click the 'People' link.
    expect(page).to have_content inviter.full_name # Tom Smith should be following Alice.
    sign_out  
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "Tom Smith" # We expect Alice to also be following Tom Smith.
  end
end