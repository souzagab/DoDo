RSpec.describe Task do

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }
  end

  describe ".search" do
    let!(:task) { create(:task, body: "foo") }
    let!(:other_task) { create(:task, body: "bar") }
    let!(:another_task) { create(:task, body: "baz") }

    let(:all_tasks) { [task, other_task, another_task] }
    let(:search_params) { { q: "ba" }.with_indifferent_access }

    it "returns all tasks when no search params are given" do
      expect(described_class.search({})).to match_array(all_tasks)
    end

    it "returns tasks matching the search params" do
      expect(described_class.search(search_params)).to contain_exactly(other_task, another_task)
    end
  end
end
