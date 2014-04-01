require 'spec_helper'

feature 'User following' do
  scenario "user follows and unfollows someone" do
    daddy = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: daddy, video: video)

    sign_in
    click_on_video_on_home_page(video)

    click_link daddy.full_name
    click_link "Follow"
    expect(page).to have_content(daddy.full_name)

    unfollow(daddy)
    expect(page).not_to have_content(daddy.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end