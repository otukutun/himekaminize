RSpec.describe Himekaminize::TaskList do
  let(:task_list) do
    described_class.new(markdown)
  end

  describe "#to_a" do
    subject do
      task_list.to_a
    end

    context "empty array" do
      let(:markdown) { "" }

      it { is_expected.to eq [] }
    end

  end
end
