RSpec.describe Device do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "attributes" # TODO: Test attributes encryption
end
