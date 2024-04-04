FactoryBot.define do
    factory :ticket do
      user { association :user }
      event { association :event }
      quantity { 1 }
    end
end