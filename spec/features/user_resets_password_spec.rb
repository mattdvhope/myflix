require 'spec_helper'

feature 'User Resets Password' do
  scenario 'user successfully resets the password' do
    alice = Fabricate(:user, password: 'old_password')

    # Sign in page...
    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: alice.email
    click_button "Send Email"

    open_email(alice.email) # With this line, we're starting to use the capybara-email gem with its provided methods.
    current_email.click_link("Reset My Password")

    # Reset password page...
    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    # Sign in page...
    fill_in "Email Address", with: alice.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"
    expect(page).to have_content("Welcome, #{alice.full_name}")
  end
end