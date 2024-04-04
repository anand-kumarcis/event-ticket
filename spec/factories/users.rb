# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password { 'Test@12345' }
  end
end
