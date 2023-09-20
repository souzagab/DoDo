FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password_digest { BCrypt::Password.create(Faker::Internet.password) }
    verified { true }

    trait :unverified do
      verified { false }
    end
  end
end
