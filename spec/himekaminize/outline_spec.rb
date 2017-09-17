RSpec.describe Himekaminize::Outline do
  let(:outline) do
    described_class.new(default_context)
  end

  describe "#call" do
    subject do
      outline.call(markdown, context)
    end

    let(:default_context) { {} }

    context "empty result" do
      let(:markdown) { "" }
      let(:context) { {} }

      it { is_expected.to eq context: {}, output: [], markdown: "" }
    end

    context "simple text" do
      let(:markdown) { "# 最近はElasticsearchなるものに興味がある。\r\n## あとで少し調べてみよう。\r\n## 今日のやること" }
      let(:context) { {} }

      it { expect(subject[:output].map(&:name)).to eq [" 最近はElasticsearchなるものに興味がある。\r", " あとで少し調べてみよう。\r", " 今日のやること"] }
      it { expect(subject[:output].map(&:level)).to eq ["#", "##", "##"] }
    end

    context "only task list option is true" do
      let(:markdown) { "# 最近はElasticsearchなるものに興味がある。\r\n## あとで少し調べてみよう。\r\n## 今日のやること\r\n今日はなにをやろうかな\r\n今日はなにをやろうかな\r\n### 今日はなにをやろうかな\n" }
      let(:context) { { only_header: true } }

      it { expect(subject[:context][:only_header]).to eq true }

      it { expect(subject[:output].map(&:name)).to eq [" 最近はElasticsearchなるものに興味がある。\r", " あとで少し調べてみよう。\r", " 今日のやること\r", " 今日はなにをやろうかな"] }
      it { expect(subject[:output].map(&:size)).to eq [1, 2, 2, 3] }
    end
  end
end
