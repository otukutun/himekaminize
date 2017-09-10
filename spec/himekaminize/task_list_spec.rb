RSpec.describe Himekaminize::TaskList do
  let(:task_list) do
    described_class.new(default_context)
  end

  describe "#call" do
    subject do
      task_list.call(markdown, context)
    end

    let(:default_context) { {} }

    context "empty result" do
      let(:markdown) { "" }
      let(:context) { {} }

      it { is_expected.to eq context: {}, output: [], markdown: "" }
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
      let(:context) { {} }

      it { expect(subject[:output]).to eq ["# 最近はElasticsearchなるものに興味がある。\n", "## あとで少し調べてみよう。\n", "## 今日のやること"] }
    end

    context "only task list option is true" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\n  - [ ] あとで少し調べてみよう。\n  - [x] 今日のやること\n\r今日はなにをやろうかな\n今日はなにをやろうかな\n今日はなにをやろうかな\n" }
      let(:context) { { only_task_list: true } }

      it { expect(subject[:context][:only_task_list]).to eq true }

      it { expect(subject[:output].map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。", "あとで少し調べてみよう。", "今日のやること"] }
      it { expect(subject[:output].map(&:sequence)).to eq [1, 2, 3] }
      it { expect(subject[:output].map(&:status)).to eq %i(incomplete incomplete complete) }
    end

    context "update task list" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\n  - [ ] あとで少し調べてみよう。\n  - [x] 今日のやること\n\r今日はなにをやろうかな\n今日はなにをやろうかな\n今日はなにをやろうかな\n" }
      let(:context) { { only_task_list: true, update_task_status_list: [{sequence: 1, status: :complete}, {sequence: 2, status: :complete}, {sequence: 3, status: :incomplete}] } }

      it { expect(subject[:context][:update_task_status_list]).to eq [{sequence: 1, status: :complete}, {sequence: 2, status: :complete}, {sequence: 3, status: :incomplete}] }

      it { expect(subject[:output].map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。", "あとで少し調べてみよう。", "今日のやること"] }
      it { expect(subject[:output].map(&:sequence)).to eq [1, 2, 3] }
      it { expect(subject[:output].map(&:status)).to eq %i(complete complete incomplete) }

      it { expect(subject[:markdown]).to eq "- [x] 最近はElasticsearchなるものに興味がある。  - [x] あとで少し調べてみよう。  - [ ] 今日のやること" }
    end
  end
end
