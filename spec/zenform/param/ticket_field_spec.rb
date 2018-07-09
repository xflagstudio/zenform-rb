RSpec.describe Zenform::Param::TicketField do
  let(:klass)    { Zenform::Param::TicketField }
  let(:instance) { klass.new content }
  let(:content)  { content_title }

  let(:content_title) do
    {
      "title" => "Title",
      "type" => "text"
    }
  end
  let(:content_platform) do
    {
      "title" => "Platform",
      "type" => "tagger",
      "custom_field_options" => [
        { "name" => "App Store",         "value" => "app_store" },
        { "name" => "Google Play Store", "value" => "google_play_store" },
        { "name" => "Amazon Appstore",   "value" => "amazon_appstore" }
      ]
    }
  end

  describe "#validate!" do
    subject { -> { instance.validate! } }
    context "invalid" do
      context "no title" do
        let(:content) { content_title.merge "title" => nil }
        it { is_expected.to raise_error Zenform::ContentError }
      end
      context "no type" do
        let(:content) { content_title.merge "type" => nil }
        it { is_expected.to raise_error Zenform::ContentError }
      end
      context "custom_field_options is empty when type is tagger" do
        let(:content) { content_platform.merge "custom_field_options" => [] }
        it { is_expected.to raise_error Zenform::ContentError }
      end
    end
    context "valid" do
      context "when type is not tagger" do
        let(:content) { content_title }
        it { is_expected.not_to raise_error }
      end
      context "when type is tagger" do
        let(:content) { content_platform }
        it { is_expected.not_to raise_error }
      end
    end
  end
end
