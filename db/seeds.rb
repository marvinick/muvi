# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Video.create(title: "Futurama", description: "Philip J Fry blah blah",
             small_cover_url: "/tmp/futurama.jpg",
             large_cover_url: "/tmp/futurama_large.jpg",
             category_id: 3)
Video.create(title: "Family Guy", description: "Seth McFarlane blah blah Canada sucks",
             small_cover_url: "/tmp/family_guy.jpg",
             large_cover_url: "/tmp/family_guy_large.jpg")
Video.create(title: "Monk", description: "OCD detective shenanigans",
             small_cover_url: "/tmp/monk.jpg",
             large_cover_url: "/tmp/monk_large.jpg",
             category_id: 1)
Video.create(title: "South Park", description: "Fourth grade political commentary",
             small_cover_url: "/tmp/south_park.jpg",
             large_cover_url: "/tmp/south_park_large.jpg",
              category_id: 2)

Category.create(name: "TV Comedies")
Category.create(name: "TV Dramas")
Category.create(name: "Action Movies")
