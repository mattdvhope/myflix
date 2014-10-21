require 'spec_helper'

feature 'User registers', { vcr: true, js: true } do
  scenario "with valid user info and valid card" do
    visit register_path
    fill_in "Email Address", with: "matt@email.test"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Matt Test"

    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2018", from: "date_year"

    click_button "Sign Up"

    expect(page).to have_content("Thanks for your payment.")
  end
  scenario "with valid user info and invalid card"
  scenario "with valid user info and declined card"
  scenario "with invalid user info and valid card"
  scenario "with invalid user info and invalid card"
  scenario "with invalid user info and declined card"
end