RSpec.describe Task do
  subject(:task) { build(:task) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "attributes" do
    it do
      expect(task).to define_enum_for(:status)
          .backed_by_column_of_type(:enum)
          .with_values(open: "open", closed: "closed", archived: "archived")
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }

    describe "due_date" do
      it "is expected to be greater than or equal to today" do
        task.due_date = 1.day.ago
        expect(task).not_to be_valid
      end
    end
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
