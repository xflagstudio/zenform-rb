RSpec.describe Zenform::Param::TicketForm do
  let(:klass)    { Zenform::Param::TicketForm }
  let(:instance) { klass.new content, ticket_fields: ticket_fields }
  let(:content)  { base_content }
  let(:base_content) do
    {
      "name" => "User Info",
      "position" => 100,
      "ticket_field_ids" => %w{os user_id}
    }
  end

  let(:ticket_fields) { base_ticket_fields }
  let(:base_ticket_fields) { { "os" => ticket_field_os, "user_id" => ticket_field_user_id } }
  let(:ticket_field_os) { ZendeskAPI::TicketField.new client, id: 100, name: "os" }
  let(:ticket_field_user_id) { ZendeskAPI::TicketField.new client, id: 99, name: "user_id" }
  let(:client) { double "ZendeskAPI::Client" }

  describe "#validate!" do
    subject { -> { instance.validate! } }
    context "invalid" do
      context "no name" do
        let(:content) { base_content.merge "name" => nil }
        it { is_expected.to raise_error Zenform::ContentError }
      end
      context "no position" do
        let(:content) { base_content.merge "position" => nil }
        it { is_expected.to raise_error Zenform::ContentError }
      end
      context "ticket_fields includes invalid slug" do
        let(:ticket_fields) { base_ticket_fields.except "os" }
        it { is_expected.to raise_error Zenform::ContentError }
      end
    end
    context "valid" do
      it { is_expected.not_to raise_error }
    end
  end

  describe "#format" do
    subject { instance.format }
    let(:expected) do
      Zenform::Param::TicketForm.new({}).to_h.merge(content).merge(
        "ticket_field_ids" => [ticket_field_os.id, ticket_field_user_id.id]
      )
    end
    it { is_expected.to eq expected }
  end
end
