RSpec.describe Task, type: :model do
  it { is_expected.to validate_presence_of(:body) }
end
