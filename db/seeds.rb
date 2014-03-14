# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


video = Video.create(title: "Futurama", description: "Never watched this shit", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg")
video = Video.create(title: "Family Guy", description: "Never watched this shit either", small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg")
video = Video.create(title: "Monk", description: "I have seen this crap", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg")
video = Video.create(title: "South Park", description: "People talk about this a lot", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/monk_large.jpg")