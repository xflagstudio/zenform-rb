RSpec.describe Zenform::Param::Base do
  module Zenform
    module Param
      class DummyContent < Base
        FIELDS = %w{title body}
        FIELDS.each { |f| attr_reader f }
      end
    end
  end

  let(:dummy_klass)    { Zenform::Param::DummyContent }
  let(:dummy_instance) { dummy_klass.new content }
  let(:content)        { { "title" => "dummy_title" } }

  describe "#reject_blank_field" do
    subject { dummy_instance.reject_blank_field(hash) }
    let(:hash) { content.merge "body" => "", "conditions" => { "all" => [], "any" => [] }, "actions" => [], "position" => nil }
    it { is_expected.to eq content }
  end
  describe "#validate_field!" do
    context "one arg" do
      subject { -> { dummy_instance.validate_field! field } }
      context "invalid" do
        let(:field) { "body" }
        it { is_expected.to raise_error Zenform::ContentError }
      end
      context "valid" do
        let(:field) { "title" }
        it { is_expected.not_to raise_error }
      end
    end
    context "two arg" do
      subject { -> { dummy_instance.validate_field! field, value } }
      context "body" do
        let(:field) { "title" }
        let(:value) { nil }
        it { is_expected.to raise_error Zenform::ContentError }
      end
      context "valid" do
        let(:field) { "body" }
        let(:value) { "dummy_body" }
        it { is_expected.not_to raise_error }
      end
    end
  end
end
