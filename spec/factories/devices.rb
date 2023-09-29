FactoryBot.define do
  factory :device do
    user
    endpoint { Faker::Internet.url }
    p256dh { Faker::Internet.password }
    auth { Faker::Internet.password }
    expiration_time { nil }
  end
end
