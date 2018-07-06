RSpec.describe Zenform::Commands::Apply::TicketForm do
  let(:command) { Zenform::Commands::Apply::TicketForm.new(client, project_path, contents, shell) }
  let(:client) { double "ZendeskAPI::Client" }
  let(:shell) { double "ThorShell" }
  let(:project_path) { "/path/to/project" }
  let(:contents) { {} }

  describe ".extra_params" do
    subject { command.send :extra_params }
    let(:ticket_fields) { { "ticket_field_os" => { "name" => "os", "id" => 1 } } }
    before { allow(Zenform::FileCache).to receive(:read).with(project_path, "ticket_fields").and_return(ticket_fields) }
    it { is_expected.to eq({ ticket_fields: ticket_fields }) }
  end
end
