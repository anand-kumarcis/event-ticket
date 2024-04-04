# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { 'Event1' }
    description { 'desc' }
    location  { "Las Angles" }
    date   {  DateTime.now.strftime('%Y-%m-%d') }
    time   { "12:00" }
    total_tickets { 20 }
    booked_tickets { 0 }
    association :user
  end
end
