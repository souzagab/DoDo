RSpec.describe PasswordResetToken do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end
