FactoryBot.define do
  factory :session do
    user { create(:user) }
  end
end
