RSpec.describe User do

  describe "callbacks"

  describe "associations" do
    it { is_expected.to have_many(:email_verification_tokens).dependent(:destroy) }
    it { is_expected.to have_many(:password_reset_tokens).dependent(:destroy) }
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
  end

  describe "validations" do
    xdescribe "uniqueness" do
      subject(:user) { create(:user) }

      it { is_expected.to validate_uniqueness_of(:email) }
    end

    it { is_expected.to validate_presence_of(:email) }
  end
end
