require 'spec_helper'

feature 'User registers', { vcr: true, js: true } do
  background do
    visit register_path
  end

  scenario "with valid user info and valid card" do
    fill_in_valid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(page).to have_content("Thanks for your payment.")
  end

  scenario "with valid user info and invalid card" do
    fill_in_valid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid") # This is the error message that Stripe sends back for an invalid card.
  end

  scenario "with valid user info and declined card" do
    fill_in_valid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined")
  end

  scenario "with invalid user info and valid card" do
    fill_in_invalid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end
  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid") # This is the error message that Stripe sends back for an invalid card. Same as for the second test above.
  end
  scenario "with invalid user info and declined card" do # Won't attempt to charge credit card.
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end
end

def fill_in_valid_user_info
  fill_in "Email Address", with: "matt@email.test"
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "Matt Test"
end

def fill_in_valid_card
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  select "10 - October", from: "date_month"
  select "2018", from: "date_year"
end

def fill_in_invalid_card
  fill_in "Credit Card Number", with: "777"
  fill_in "Security Code", with: "123"
  select "10 - October", from: "date_month"
  select "2018", from: "date_year"
end

def fill_in_declined_card
  fill_in "Credit Card Number", with: "4000000000000002"
  fill_in "Security Code", with: "123"
  select "10 - October", from: "date_month"
  select "2018", from: "date_year"
end

def fill_in_invalid_user_info
  fill_in "Email Address", with: "matt@email.test"
  fill_in "Full Name", with: "Matt Test"
end





