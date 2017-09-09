RSpec.describe Himekaminize::TaskList do
  let(:task_list) do
    described_class.new(default_context)
  end

  describe "#call" do
    subject do
      task_list.call(markdown)
    end

    let(:default_context) { {} }

    context "empty result" do
      let(:markdown) { "" }
      let(:context) { {} }

      it { is_expected.to eq context: {}, output: [] }
    end

    context "simple text" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\n  - [ ] あとで少し調べてみよう。\n  - [x] 今日のやること" }
      let(:context) { {} }

      it { expect(subject[:output].map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。", "あとで少し調べてみよう。", "今日のやること"] }
      it { expect(subject[:output].map(&:sequence)).to eq [1, 2, 3] }
      it { expect(subject[:output].map(&:status)).to eq %i(incomplete incomplete complete) }
    end

    context "non task list text" do
      let(:markdown) { "# 最近はElasticsearchなるものに興味がある。\n## あとで少し調べてみよう。\n## 今日のやること" }

      it { expect(subject[:output]).to eq ["# 最近はElasticsearchなるものに興味がある。\n", "## あとで少し調べてみよう。\n", "## 今日のやること"] }
    end
  end
end
