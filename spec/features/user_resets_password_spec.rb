require 'spec_helper'

feature 'User resets password' do
  scenario 'user successfully resets the password' do
    daddy = Fabricate(:user, password: 'old_password')
    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: daddy.email
    click_button "Send Email"

    open_email(daddy.email)
    current_email.click_link("Reset my password")

    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: daddy.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"
    expect(page).to have_content("Welcome, #{daddy.full_name}")
  end
end