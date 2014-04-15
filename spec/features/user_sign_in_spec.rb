require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    daddy = Fabricate(:user)
    sign_in(daddy)
    page.should have_content daddy.full_name
  end

  scenario "with deactivated user" do
    daddy = Fabricate(:user, active: false)
    sign_in(daddy)
    expect(page).not_to have_content(daddy.full_name)
    expect(page).to have_content("You are being suspended from the site, please contact CS")
  end

end