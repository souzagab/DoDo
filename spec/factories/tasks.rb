FactoryBot.define do
  factory :task do
    body { Faker::Lorem.sentence }
  end
end
