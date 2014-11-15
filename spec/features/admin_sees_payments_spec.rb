require 'spec_helper'

feature "Admin sees payments" do
  background do
    alice = Fabricate(:user, full_name: "Alice Doe", email: "alice@email.com")
    Fabricate(:payment, amount: 999, user: alice)
  end
  scenario "admin can see payments" do
    sign_in(Fabricate(:admin)) # From 'spec/support/macros.rb'
    visit admin_payments_path # Make sure to add this in 'routes.rb' ... 'resources :payments, only: [:index]' within 'namespace :admin' 
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice Doe")
    expect(page).to have_content("alice@email.com")
  end
  scenario "user cannot see payments" do
    sign_in(Fabricate(:user)) # From 'spec/support/macros.rb'
    visit admin_payments_path # Make sure to add this in 'routes.rb' ... 'resources :payments, only: [:index]' within 'namespace :admin' 
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Alice Doe")
    expect(page).to have_content("You are not authorized to do that.") # from 'controllers/admins_controller.rb'
  end
end