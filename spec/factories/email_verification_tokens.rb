FactoryBot.define do
  factory :email_verification_token do
    user { create(:user) }
  end
end
