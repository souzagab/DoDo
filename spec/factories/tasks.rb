FactoryBot.define do
  factory :task do
    body { Faker::Lorem.sentence }
    status { "open" }
    due_date { nil }
  end
end
