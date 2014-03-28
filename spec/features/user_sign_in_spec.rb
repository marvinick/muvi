require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    daddy = Fabricate(:user)
    sign_in(daddy)
    page.should have_content daddy.full_name
  end
end