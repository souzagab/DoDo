RSpec.describe User do

  describe "callbacks"

  describe "associations" do
    it { is_expected.to have_many(:email_verification_tokens).dependent(:destroy) }
    it { is_expected.to have_many(:password_reset_tokens).dependent(:destroy) }
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
    it { is_expected.to have_many(:registered_devices).class_name("Device").dependent(:destroy) }
  end

  describe "validations" do
    describe "uniqueness" do
      subject(:user) { create(:user) }

      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

    it { is_expected.to validate_presence_of(:email) }
  end
end
