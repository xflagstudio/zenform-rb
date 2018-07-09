RSpec.describe Zenform::Param::Trigger do
  let(:klass)    { Zenform::Param::Trigger }
  let(:instance) { klass.new content, ticket_fields: ticket_fields, ticket_forms: ticket_forms }
  let(:content)  { base_content }
  let(:base_content) do
    {
      "title" => "Change Form",
      "position" => 2,
      "conditions" => {
        "all" => [{ "field" => "ticket_form_id", "operator" => "is", "value" => "ticket_form_user" }],
        "any" => [{ "field" => "ticket_field_user_id", "operator" => "is", "value" => "iOS" }],
      },
      "actions" => [{ "field" => "ticket_form_id", "value" => ["ticket_form_agent"] }]
    }
  end

  let(:client) { double "ZendeskAPI::Client" }
  let(:ticket_fields) { base_ticket_fields }
  let(:base_ticket_fields) { { "ticket_field_os" => ticket_field_os, "ticket_field_user_id" => ticket_field_user_id } }
  let(:ticket_field_os) { { "id" => 100, "name" => "os" } }
  let(:ticket_field_user_id) { { "id" => 99, "name" => "user_id" } }
  let(:ticket_forms) { base_ticket_forms }
  let(:base_ticket_forms) { { "ticket_form_agent" => ticket_form_agent, "ticket_form_user" => ticket_form_user } }
  let(:ticket_form_agent) { { "id" => 200, "name" => "For agent" } }
  let(:ticket_form_user) { { "id" => 201, "name" => "For user" } }

  describe "#conditions" do
    subject { instance.conditions }
    it { expect(subject.values.flatten).to all(be_an_instance_of(Zenform::Param::Condition)) }
  end

  describe "#actions" do
    subject { instance.actions }
    it { is_expected.to all(be_an_instance_of(Zenform::Param::Action)) }
  end
  describe "#validate!" do
    subject { -> { instance.validate! } }
    context "invalid" do
      let(:content) do
        base_content["conditions"]["all"][0]["value"] = "hoge"
        base_content
      end
      it { is_expected.to raise_error Zenform::ContentError }
    end
    context "valid" do
      it { is_expected.not_to raise_error }
    end
  end

  describe "#format" do
    subject { instance.format }
    let(:expected) do
      {
        "title" => "Change Form",
        "position" => 2,
        "conditions" => {
          "all" => [{ "field" => "ticket_form_id", "operator" => "is", "value" => ticket_form_user["id"] }],
          "any" => [{ "field" => "custom_fields_#{ticket_field_user_id['id']}", "operator" => "is", "value" => "iOS" }],
        },
        "actions" => [{ "field" => "ticket_form_id", "value" => ticket_form_agent["id"] }]
      }
    end
    it { is_expected.to eq expected }
  end
end
