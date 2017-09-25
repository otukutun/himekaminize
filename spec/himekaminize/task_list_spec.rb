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
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\r\n  - [ ] あとで少し調べてみよう。\r\n  - [x] 今日のやること" }
      let(:context) { {} }

      it { expect(subject[:output].map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。\r", "あとで少し調べてみよう。\r", "今日のやること"] }
      it { expect(subject[:output].map(&:seq)).to eq [1, 2, 3] }
      it { expect(subject[:output].map(&:status)).to eq %i(incomplete incomplete complete) }
      it { expect(subject[:output].map(&:depth)).to eq [0, 1, 1] }
      it { expect(subject[:output].map(&:parent_seq)).to eq [nil, 1, 1] }
    end

    context "non task list text" do
      let(:markdown) { "# 最近はElasticsearchなるものに興味がある。\r\n## あとで少し調べてみよう。\r\n## 今日のやること" }
      let(:context) { {} }

      it { expect(subject[:output]).to eq ["# 最近はElasticsearchなるものに興味がある。\r\n", "## あとで少し調べてみよう。\r\n", "## 今日のやること"] }
    end

    context "only task list option is true" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\r\n  - [ ] あとで少し調べてみよう。\r\n  - [x] 今日のやること\r\n今日はなにをやろうかな\r\n今日はなにをやろうかな\r\n今日はなにをやろうかな\n" }
      let(:context) { { only_task_list: true } }

      it { expect(subject[:context][:only_task_list]).to eq true }

      it { expect(subject[:output].map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。\r", "あとで少し調べてみよう。\r", "今日のやること\r"] }
      it { expect(subject[:output].map(&:seq)).to eq [1, 2, 3] }
      it { expect(subject[:output].map(&:status)).to eq %i(incomplete incomplete complete) }
      it { expect(subject[:output].map(&:depth)).to eq [0, 1, 1] }
      it { expect(subject[:output].map(&:parent_seq)).to eq [nil, 1, 1] }
    end

    context "update task list" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\r\n  - [ ] あとで少し調べてみよう。\r\n  - [x] 今日のやること\r\n今日はなにをやろうかな\r\n今日はなにをやろうかな\r\n今日はなにをやろうかな\n" }
      let(:context) { { only_task_list: true, update_task_status_list: [{seq: 1, status: :complete}, {seq: 2, status: :complete}, {seq: 3, status: :incomplete}] } }

      it { expect(subject[:context][:update_task_status_list]).to eq [{seq: 1, status: :complete}, {seq: 2, status: :complete}, {seq: 3, status: :incomplete}] }

      it { expect(subject[:output].map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。\r", "あとで少し調べてみよう。\r", "今日のやること\r"] }
      it { expect(subject[:output].map(&:seq)).to eq [1, 2, 3] }
      it { expect(subject[:output].map(&:status)).to eq %i(complete complete incomplete) }
      it { expect(subject[:output].map(&:depth)).to eq [0, 1, 1] }
      it { expect(subject[:output].map(&:parent_seq)).to eq [nil, 1, 1] }

      it { expect(subject[:markdown]).to eq "- [x] 最近はElasticsearchなるものに興味がある。\r\n  - [x] あとで少し調べてみよう。\r\n  - [ ] 今日のやること\r\n" }
    end

    context "attach depth and parent_seq" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\r\n  - [ ] あとで少し調べてみよう。\r\n  - [ ] 今日のやること\r\n    - [x] 朝顔に水をやる\r\n    - [ ] 朝ごはん食べる\r\n今日はなにをやろうかな\n" }
      let(:context) { { only_task_list: true } }

      it { expect(subject[:context][:only_task_list]).to eq true }
      it { expect(subject[:output].map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。\r", "あとで少し調べてみよう。\r", "今日のやること\r", "朝顔に水をやる\r", "朝ごはん食べる\r"] }
      it { expect(subject[:output].map(&:seq)).to eq [1, 2, 3, 4, 5] }
      it { expect(subject[:output].map(&:status)).to eq %i(incomplete incomplete incomplete complete incomplete) }
      it { expect(subject[:output].map(&:depth)).to eq [0, 1, 1, 2, 2] }
      it { expect(subject[:output].map(&:parent_seq)).to eq [nil, 1, 1, 3, 3] }
    end

    context "attach depth and parent_seq to multi task list" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\r\nここで一旦おわり\r\n  - [ ] Elasticsearchチュートリアル\r\n  - [x] Python勉強\n" }
      let(:context) { { only_task_list: true } }

      it { expect(subject[:context][:only_task_list]).to eq true }
      it { expect(subject[:output].map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。\r", "Elasticsearchチュートリアル\r", "Python勉強"] }
      it { expect(subject[:output].map(&:seq)).to eq [1, 2, 3] }
      it { expect(subject[:output].map(&:status)).to eq %i(incomplete incomplete complete) }
      it { expect(subject[:output].map(&:depth)).to eq [0, 0, 0] }
      it { expect(subject[:output].map(&:parent_seq)).to eq [nil, nil, nil] }
    end
  end
end
