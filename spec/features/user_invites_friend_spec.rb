require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    daddy = Fabricate(:user)
    sign_in(daddy)

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    friend_should_follow(daddy)

    sign_in(daddy)
    click_link "People"
    expect(page).to have_content "Daddy O"

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Daddy O"
    fill_in "Friend's Email Address", with: "daddy_o@daddy.com"
    fill_in "Message", with: "Hi join me please"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email "daddy_o@daddy.com"
    current_email.click_link "I'd like to join"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Daddy O"
    click_button "Sign Up"
  end

  def friend_signs_in
    fill_in "Email Address", with: "daddy_o@daddy.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end
end

