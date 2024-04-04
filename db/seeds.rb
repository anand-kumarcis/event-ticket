# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create(email: 'user123@email.com', password: '123456')
N_EVENTS = 200
N_EVENTS.times do |i|
  Event.create(name: "Event_0#{i}", description: "desc", location: "location", date: DateTime.now, time: "12:00", total_tickets: 20, booked_tickets: 0, user_id: user.id)
end

user2 = User.create(email: "user456@email.com", password: '123456')
N_EVENTS2 = 200
N_EVENTS2.times do |i|
  Event.create(name: "Event_1#{i}", description: "desc", location: "location", date: DateTime.now, time: "12:00", total_tickets: 20, booked_tickets: 0, user_id: user2.id)
end
