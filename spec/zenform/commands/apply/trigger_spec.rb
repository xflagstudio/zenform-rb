RSpec.describe Zenform::Commands::Apply::Trigger do
  let(:command) { Zenform::Commands::Apply::Trigger.new(client, project_path, contents, shell) }
  let(:client) { double "ZendeskAPI::Client" }
  let(:shell) { double "ThorShell" }
  let(:project_path) { "/path/to/project" }
  let(:contents) { {} }

  describe ".extra_params" do
    subject { command.send :extra_params }
    let(:ticket_fields) { { "ticket_field_os" => { "name" => "os", "id" => 1 } } }
    let(:ticket_forms) { { "ticket_form_agent" => { "name" => "For agent", "id" => 10 } } }
    before do
      allow(Zenform::FileCache).to receive(:read).with(project_path, "ticket_fields").and_return(ticket_fields)
      allow(Zenform::FileCache).to receive(:read).with(project_path, "ticket_forms").and_return(ticket_forms)
    end
    it { is_expected.to eq({ ticket_fields: ticket_fields, ticket_forms: ticket_forms }) }
  end
end
