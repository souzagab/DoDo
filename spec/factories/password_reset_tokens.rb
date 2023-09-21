FactoryBot.define do
  factory :password_reset_token do
    user { create(:user) }
  end
end
