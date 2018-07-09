RSpec.describe Zenform::Commands::Apply::Base do
  module Zenform
    module Commands
      module Apply
        class DummyContentForApplySpec < Base
          private

          def extra_params
            {}
          end

          def content_name
            :dummy_contents
          end
        end
      end
    end
  end

  module Zenform
    module Param
      class DummyContentForApplySpec < Base
        FIELDS = %w{name}
        attr_reader :name

        def validate!
          # nop
        end

        def format
          to_h
        end
      end
    end
  end

  let(:dummy_class)     { Zenform::Commands::Apply::DummyContentForApplySpec }
  let(:dummy_instance)  { dummy_class.new client, project_path, new_contents, shell }
  let(:client)          { double("ZendeskClient") }
  let(:shell)           { double("ThorShell") }
  let(:project_path)    { File.expand_path "../../../fixtures/", File.dirname(__FILE__) }
  let(:new_contents)    { { "ticket_field_title" => content_title, "ticket_field_body" => content_body, "ticket_field_os" => content_os } }
  let(:cached_contents) { { "ticket_field_title" => content_title } }
  let(:content_name)    { :dummy_contents }
  let(:cache_path)      { Zenform::FileCache.send :create_file_path, project_path, content_name }

  let(:content_title) { { "name" => "title" } }
  let(:content_body)  { { "name" => "body" } }
  let(:content_os)    { { "name" => "os" } }

  after do
    File.delete cache_path if File.exists? cache_path
  end

  describe "#initialize" do
    it "sets attributes" do
      expect(dummy_instance.client).to eq client
      expect(dummy_instance.project_path).to eq project_path
      expect(dummy_instance.new_contents.keys).to match_array new_contents.keys
      expect(dummy_instance.new_contents.values).to all(be_an_instance_of(Zenform::Param::DummyContentForApplySpec))
    end
  end

  describe "#run" do
    subject { dummy_instance.run }

    before do
      allow(dummy_instance).to receive(:not_created_contents).and_return(%w{ticket_field_body ticket_field_os})
    end

    it "updates cache file" do
      expect(dummy_instance).not_to receive(:create).with(anything, "ticket_field_title")
      expect(dummy_instance).to receive(:create).with(anything, "ticket_field_body").and_return(nil)
      expect(dummy_instance).to receive(:create).with(anything, "ticket_field_os").and_return(content_os)
      expect { subject }.to change { (Zenform::FileCache.read(project_path, content_name) || {}).keys }.by(["ticket_field_os"])
    end
  end

  describe "#cached_contents" do
    subject { dummy_instance.send :cached_contents }
    context "no cache file" do
      it { is_expected.to eq({}) }
    end
    context "cache file" do
      before do
        Zenform::FileCache.write project_path, content_name, cached_contents
      end

      it { is_expected.to eq cached_contents }
    end
  end

  describe "#not_created_contents" do
    subject { dummy_instance.send :not_created_contents }

    before do
      allow(dummy_instance).to receive(:cached_contents).and_return(cached_contents)
    end
    context "already_created is empty" do
      let(:cached_contents) { {} }
      it "returns original new_contents" do
        expect(shell).not_to receive(:say)
        expect(subject.keys).to match_array(new_contents.keys)
      end
    end
    context "already_created is not empty" do
      it "extracts new_contents and outputs skipped message" do
        expect(shell).to receive(:say)
        expect(shell).to receive(:indent)
        expect(subject.keys).to match_array(new_contents.keys - cached_contents.keys)
      end
    end
  end

  describe "#create" do
    subject { dummy_instance.send :create, Zenform::Param::DummyContentForApplySpec.new(content_title) }
    context "not raise error" do
      before { allow(client).to receive_message_chain(:dummy_contents, :create!).and_return(ZendeskAPI::TicketField.new(content_title)) }
      it "puts success message and returns true" do
        expect(shell).to receive(:say).with(anything, :green)
        expect(subject).to be_truthy
      end
    end
    context "raise error" do
      before { allow(client).to receive_message_chain(:dummy_contents, :create!).and_raise(ZendeskAPI::Error::ClientError.new("dummy")) }
      it "puts failed message and returns false" do
        expect(shell).to receive(:say).with(anything, :red)
        expect(subject).to be_falsy
      end
    end
  end
end
