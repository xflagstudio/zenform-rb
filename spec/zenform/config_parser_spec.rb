RSpec.describe Zenform::ConfigParser do
  describe ".parse" do
    subject { Zenform::ConfigParser.parse project_path }
    let(:project_path) { File.expand_path("../fixtures/", File.dirname(__FILE__)) }
    let(:dummy_config) { "config" }
    before { allow(Zenform::ConfigParser).to receive(:load_config).and_return(dummy_config) }
    let(:expected) do
      {
        "auth_info"    => dummy_config,
        "ticket_field" => dummy_config,
        "ticket_form"  => dummy_config,
        "trigger"      => dummy_config
      }
    end
    it { is_expected.to eq expected }
  end

  describe ".load_config" do
    subject { Zenform::ConfigParser.send :load_config, project_path, format }
    let(:project_path) { File.expand_path("../fixtures/", File.dirname(__FILE__)) }
    let(:format) do
      {
        "path"      => "dummy_load_file.csv",
        "file_type" => "csv",
      }
    end
    context "file_type is csv" do
      it "calls Zenform::ConfigParser::CSVParser.parse" do
        expect(Zenform::ConfigParser::CSVParser).to receive(:parse)
        subject
      end
    end
  end
end
