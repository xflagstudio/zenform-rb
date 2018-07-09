RSpec.describe Zenform::CLI do
  let(:cli) { Zenform::CLI.new }

  describe "apply" do
    subject { cli.invoke :apply, [], options }

    context "with config_path" do
      let(:options) { { config_path: config_path } }
      let(:config_path) { "path/to/config" }
      it "calls run method" do
        expect(Zenform::Commands::Apply).to receive(:run).with(config_path, anything)
        subject
      end
    end
    context "without config_path" do
      let(:options) { {} }
      it "calls run method" do
        expect(Zenform::Commands::Apply).to receive(:run).with(Zenform::ConfigParser::DEFAULT_CONFIG_PATH, anything)
        subject
      end
    end
  end
end
