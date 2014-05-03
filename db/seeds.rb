# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# "Put in seed data about videos... Southpark, etc are in public/tmp/"

road = Video.create(title: "Road Runner", description: "Chased constantly!", small_cover_url: "/tmp/road_runner.jpg", large_cover_url: "/tmp/road_runner_large.jpg", category_id: 1)
bugs = Video.create(title: "Bugs Bunny", description: "A bunny with bugs.", small_cover_url: "/tmp/bugs_bunny.jpg", large_cover_url: "/tmp/bugs_bunny_large.jpg", category_id: 3)
fog = Video.create(title: "Foghorn Leghorn", description: "A large, southern rooster.", small_cover_url: "/tmp/foghorn.jpg", large_cover_url: "/tmp/foghorn_large.jpg", category_id: 2)
tj = Video.create(title: "Tom & Jerry", description: "Quite a cat & mouse scene!", small_cover_url: "/tmp/tom_jerry.jpg", large_cover_url: "/tmp/tom_jerry_large.jpg", category_id: 1)

Category.create(name: "Chase movies")
Category.create(name: "Farm shows")
Category.create(name: "Animal cartoons")

matt = User.create(email: "matt@email.tv", password: "password", full_name: "Matt Malone")
john = User.create(email: "john@email.tv", password: "password", full_name: "John Smith")

Review.create(user: john, video: road, content: "What a GREAT SHOW!!", rating: 4)
Review.create(user: matt, video: bugs, content: "It's a so-so show...", rating: 2)
Review.create(user: john, video: fog, content: "It's a FANTANSTIC PROGRAM!!", rating: 5)
Review.create(user: matt, video: tj, content: "It's LOUSY!!", rating: 1)

