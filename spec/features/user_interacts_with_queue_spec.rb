require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do

    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    futurama = Fabricate(:video, title: "Futurama", category: comedies)

    sign_in
    find("a[href='/videos/#{monk.id}']").click
    page.should have_content(monk.title)

    click_link "+ My Queue"
    page.should have_content(monk.title)

    visit video_path(monk)
    page.should_not have_content "+ My Queue"

    visit home_path
    find("a[href='/videos/#{south_park.id}']").click
    click_link "+ My Queue"
    visit home_path
    find("a[href='/videos/#{futurama.id}']").click
    click_link "+ My Queue"

    find("input[data-video-id='#{monk.id}']").set(3)
    find("input[data-video-id='#{south_park.id}']").set(1)
    find("input[data-video-id='#{futurama.id}']").set(2)

    click_button "Update Instant Queue"

    expect(find("input[data-video-id='#{south_park.id}']").value).to eq("1")
    expect(find("input[data-video-id='#{futurama.id}']").value).to eq("2")
    expect(find("input[data-video-id='#{monk.id}']").value).to eq("3")
  end
end