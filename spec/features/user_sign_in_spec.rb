require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    daddy = Fabricate(:user)
    visit sign_in_path
    fill_in "Email Address", with: daddy.email
    fill_in "Password", with: daddy.password
    click_button "Sign in"
    page.should have_content daddy.full_name
  end
end