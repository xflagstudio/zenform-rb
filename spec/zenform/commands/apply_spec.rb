RSpec.describe Zenform::Commands::Apply do
  describe ".run" do
    subject { Zenform::Commands::Apply.run project_path, shell }
    let(:project_path) { "/path/to/project" }
    let(:shell)        { double("ThorShell") }
    let(:auth_info)    { { "domain" => "hogehogefugafuga", "username" => "hoge@mixi.co.jp", "token" => "token" } }
    let(:yes)          { true }

    before do
      allow(shell).to receive(:say)
      allow(shell).to receive(:yes?).and_return(yes)
      allow(shell).to receive(:indent) { |&block| block.call }
      allow(Zenform::ConfigParser).to receive(:parse).and_return("auth_info" => auth_info)
      allow(Zenform::ZendeskClient).to receive(:create).with(auth_info.transform_keys!(&:to_sym))
    end

    context "not yes" do
      let(:yes) { false }
      it "doesn't call apply" do
        expect(Zenform::Commands::Apply::TicketField).not_to receive(:new)
        expect(Zenform::Commands::Apply::TicketForm).not_to receive(:new)
        expect(Zenform::Commands::Apply::Trigger).not_to receive(:new)
        subject
      end
    end
    context "yes" do
      it "calls apply" do
        expect(Zenform::ConfigParser).to receive(:parse).and_return("auth_info" => auth_info)
        expect(Zenform::ZendeskClient).to receive(:create).with(auth_info.transform_keys!(&:to_sym))

        expect(Zenform::Commands::Apply::TicketField).to receive_message_chain(:new, :run)
        expect(Zenform::Commands::Apply::TicketForm).to receive_message_chain(:new, :run)
        expect(Zenform::Commands::Apply::Trigger).to receive_message_chain(:new, :run)
        expect(Zenform::Commands::Apply::TicketField).to receive_message_chain(:new, :content_name)
        expect(Zenform::Commands::Apply::TicketForm).to receive_message_chain(:new, :content_name)
        expect(Zenform::Commands::Apply::Trigger).to receive_message_chain(:new, :content_name)
        subject
      end
    end
  end
end
