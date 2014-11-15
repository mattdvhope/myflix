require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    alice = Fabricate(:user)
    sign_in(alice)
    expect(page).to have_content alice.full_name
  end

  scenario "with deactivated user" do
    alice = Fabricate(:user, active: false)
    sign_in(alice)
    expect(page).not_to have_content(alice.full_name) # To make this pass, go to 'sessions_controller.rb' and add
    expect(page).to have_content("Your account has been suspended, please contact customer service.")
  end
end