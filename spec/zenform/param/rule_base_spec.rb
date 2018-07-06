RSpec.describe Zenform::Param::RuleBase do
  module Zenform
    module Param
      class DummyContentForRuleBase < RuleBase
        FIELDS = %w{field value}
        FIELDS.each { |f| attr_reader f }
      end
    end
  end
  let(:klass)    { Zenform::Param::DummyContentForRuleBase }
  let(:instance) { klass.new content, ticket_fields: ticket_fields, ticket_forms: ticket_forms }
  let(:content)  { base_content }
  let(:base_content) { { "field" => field, "value" => value } }
  let(:field)    { "ticket_form_id" }
  let(:value)    { "ticket_form_user" }

  let(:client) { double "ZendeskAPI::Client" }
  let(:ticket_fields) { base_ticket_fields }
  let(:base_ticket_fields) { { "ticket_field_os" => ticket_field_os, "ticket_field_user_id" => ticket_field_user_id } }
  let(:ticket_field_os) { { "id" => 100, "name" => "os" } }
  let(:ticket_field_user_id) { { "id" => 99, "name" => "user_id" } }
  let(:ticket_forms) { base_ticket_forms }
  let(:base_ticket_forms) { { "ticket_form_agent" => ticket_form_agent, "ticket_form_user" => ticket_form_user } }
  let(:ticket_form_agent) { { "id" => 200, "name" => "For agent" } }
  let(:ticket_form_user) { { "id" => 201, "name" => "For user" } }

  describe "#value" do
    subject { instance.value }
    context "value is not array" do
      it { is_expected.to eq "ticket_form_user" }
    end
    context "value is array" do
      context "value size is 1" do
        let(:value) { ["ticket_form_user"] }
        it { is_expected.to eq "ticket_form_user" }
      end
      context "value size is over 1" do
        let(:field) { "notification_user" }
        let(:value) { [123, "message subject", "mssage body"] }
        it { is_expected.to eq value }
      end
    end
  end

  describe "#validate!" do
    subject { -> { instance.validate! } }
    context "invalid" do
      let(:value) { "ticket_form_dummy_slug" }
      it { is_expected.to raise_error Zenform::ContentError }
    end
    context "valid" do
      it { is_expected.not_to raise_error }
    end
  end

  describe "#format" do
    subject { instance.format }
    context "value includes ticket_forms slug" do
      let(:expected) { { "field" => field, "value" => ticket_forms[value]["id"] } }
      it { is_expected.to eq expected }
    end
    context "value includes ticket_forms slug" do
      let(:field) { "ticket_field_os" }
      let(:value) { "iOS" }
      let(:expected) do
        {
          "field" => Zenform::Param::RuleBase::FIELD_PARAM_FOR_TICKET_FIELD % { id: ticket_fields[field]["id"] },
          "value" => value
        }
      end
      it { is_expected.to eq expected }
    end
  end
end
