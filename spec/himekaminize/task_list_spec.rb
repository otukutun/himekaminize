RSpec.describe Himekaminize::TaskList do
  let(:task_list) do
    described_class.new(markdown)
  end

  describe "#call" do
    subject do
      task_list.call
    end

    context "empty array" do
      let(:markdown) { "" }

      it { is_expected.to eq [] }
    end

    context "simple text" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\n  - [ ] あとで少し調べてみよう。\n  - [x] 今日のやること" }

      it { expect(subject.map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。", "あとで少し調べてみよう。", "今日のやること"] }
      it { expect(subject.map(&:sequence)).to eq [1, 2, 3] }
      it { expect(subject.map(&:status)).to eq %i(incomplete incomplete complete) }
    end

    context "non task list text" do
      let(:markdown) { "# 最近はElasticsearchなるものに興味がある。\n## あとで少し調べてみよう。\n## 今日のやること" }

      it { is_expected.to eq ["# 最近はElasticsearchなるものに興味がある。\n", "## あとで少し調べてみよう。\n", "## 今日のやること"] }
    end
  end

  describe "#to_task_list" do
    subject do
      task_list.to_task_list
    end

    context "empty array" do
      let(:markdown) { "" }

      it { is_expected.to eq [] }
    end

    context "simple text" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\n  - [ ] あとで少し調べてみよう。\n  - [x] 今日のやること" }

      it { expect(subject.map(&:name)).to eq ["最近はElasticsearchなるものに興味がある。", "あとで少し調べてみよう。", "今日のやること"] }
      it { expect(subject.map(&:sequence)).to eq [1, 2, 3] }
      it { expect(subject.map(&:status)).to eq %i(incomplete incomplete complete) }
    end

    context "non task list text" do
      let(:markdown) { "# 最近はElasticsearchなるものに興味がある。\n## あとで少し調べてみよう。\n## 今日のやること" }

      it { is_expected.to eq [] }
    end
  end

  describe "#update_task_status" do
    subject do
      task_list.call

      task_list
    end

    context "simple text" do
      let(:markdown) { "- [ ] 最近はElasticsearchなるものに興味がある。\n  - [ ] あとで少し調べてみよう。\n  - [x] 今日のやること" }
      it {
        subject.update_task_status(1, :complete)
        expect(subject.result[:task_list].first.status).to eq :complete
      }

      it {
        subject.update_task_status(2, :complete)
        expect(subject.result[:task_list][1].status).to eq :complete
      }

      it {
        subject.update_task_status(3, :incomplete)
        expect(subject.result[:task_list][2].status).to eq :incomplete
      }
    end
  end
end
