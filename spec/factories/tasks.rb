FactoryBot.define do
  factory :task do
    user
    body { Faker::Lorem.sentence }
    status { "open" }
    due_date { nil }
  end
end
