# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# "Put in seed data about videos... Southpark, etc are in public/tmp/"

cpm = Video.create(title: "Church Planting Movement", description: "We learn how to multiply churches.", small_cover_url: "/tmp/cpm.jpg", large_cover_url: "/tmp/cpm_large.jpg", category_id: 1)
goliath = Video.create(title: "David & Goliath", description: "David was a great leader!", small_cover_url: "/tmp/goliath.jpg", large_cover_url: "/tmp/goliath_large.jpg", category_id: 3)
cross = Video.create(title: "Jesus going to the Cross", description: "Jesus was the ultimate leader.", small_cover_url: "/tmp/jesus.jpg", large_cover_url: "/tmp/jesus_large.jpg", category_id: 2)
plant = Video.create(title: "Planting churches", description: "Learning how to plant a seed and watch it grow.", small_cover_url: "/tmp/planting.jpg", large_cover_url: "/tmp/planting_large.jpg", category_id: 1)

Category.create(name: "Church planting")
Category.create(name: "About Jesus")
Category.create(name: "Bible stories")

matt = User.create(email: "matt@email.tv", password: "password", full_name: "Matt Malone")
john = User.create(email: "john@email.tv", password: "password", full_name: "John Lapos")
tim = User.create(email: "john@email.tv", password: "password", full_name: "Tim Owens")

Review.create(user: john, video: cpm, content: "I want to see it multiply!!", rating: 4)
Review.create(user: matt, video: goliath, content: "What an amazing historical account!", rating: 2)
Review.create(user: john, video: cross, content: "He went to the cross for me!", rating: 5)
Review.create(user: matt, video: plant, content: "I want to see it grow!", rating: 1)

