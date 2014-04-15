require 'spec_helper'

feature "Admin sees payments" do
  background do
    daddy = Fabricate(:user, full_name: "Daddy O", email: "daddy@daddy.com")
    Fabricate(:payment, amount: 999, user: daddy)
  end

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit  admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Daddy O")
    expect(page).to have_content("daddy@daddy.com")
  end

  scenario "user cannot see the payments" do
    sign_in(Fabricate(:user))
    visit  admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Daddy O")
    expect(page).to have_content("You do not have permission to do that")
  end
end