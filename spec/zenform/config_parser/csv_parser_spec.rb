RSpec.describe Zenform::ConfigParser::CSVParser do
  describe ".parse" do
    subject { Zenform::ConfigParser::CSVParser.parse file_path, format }
    let(:file_path) { File.expand_path("../../fixtures/dummy_load_file.csv", File.dirname(__FILE__)) }
    let(:format) do
      {
        "fields" => [
          { "name" => "slug" },
          { "name" => "name" },
          { "name" => "end_user_visible" },
          { "name" => "display_name" },
          { "name" => "ticket_field_names", "type" => "json" },
        ]
      }
    end

    context "invalid" do
      before { allow(Zenform::ConfigParser::CSVParser).to receive(:combine_values).and_raise(JSON::ParserError) }
      it "raises errror Zenform::ParseError" do
        expect { subject }.to raise_error Zenform::ParseError
      end
    end

    context "valid" do
      let(:expected) do
        {
          "slug1" => {
            "name" => "name1",
            "end_user_visible" => "TRUE",
            "display_name" => "display_name1",
            "ticket_field_names" => ["field1", "field2"]
          },
          "slug2" => {
            "name" => "name2",
            "end_user_visible" => "FALSE",
            "display_name" => "display_name2",
            "ticket_field_names" => ["field1", "field3"]
          }
        }
      end
      it { is_expected.to eq expected }
    end
  end

  describe ".slice_valid_fields" do
    subject { Zenform::ConfigParser::CSVParser.send :slice_valid_fields, row, fields }
    let(:row) do
      {
        "name"             => "name1",
        "end_user_visible" => "TRUE",
        "dummy"            => "dummy"
      }
    end
    let(:fields) do
      [
        { "name" => "name" },
        { "name" => "end_user_visible" }
      ]
    end
    let(:expected) do
      {
        "name"             => "name1",
        "end_user_visible" => "TRUE"
      }
    end
    it { is_expected.to eq expected }
  end

  describe ".combine_values" do
    subject { Zenform::ConfigParser::CSVParser.send :combine_values, row, combinators }
    let(:row) do
      {
        "title"                       => "dummy",
        "custom_field_options.names"  => ["name1", "name2", "name3"],
        "custom_field_options.values" => ["tag1", "tag2", "tag3"]
      }
    end
    let(:combinators) do
      [
        {
          "dest" => "custom_field_options",
          "sources" => [
            {
              "source_name" => "custom_field_options.names",
              "key" => "name"
            },
            {
              "source_name" => "custom_field_options.values",
              "key" => "value"
            }
          ]
        }
      ]
    end

    context "no combinators" do
      let(:combinators) { nil }
      it { is_expected.to eq row }
    end
    context "combinators" do
      context "invalid" do
        context "sources' size are not same" do
          let(:row) do
            {
              "title"                       => "dummy",
              "custom_field_options.names"  => ["name1", "name2", "name3", "name4"],
              "custom_field_options.values" => ["tag1", "tag2", "tag3"]
            }
          end
          it do
            expect { subject }.to raise_error Zenform::CombineError
          end
        end
      end
      context "valid" do
        context "empty" do
          let(:row) do
            {
              "title"                       => "dummy",
              "custom_field_options.names"  => nil,
              "custom_field_options.values" => nil
            }
          end
          let(:expected) do
            {
              "title" => "dummy",
              "custom_field_options" => []
            }
          end
          it { is_expected.to eq expected }
        end
        context "not empty" do
          let(:expected) do
            {
              "title" => "dummy",
              "custom_field_options" => [
                { "name" => "name1", "value" => "tag1" },
                { "name" => "name2", "value" => "tag2" },
                { "name" => "name3", "value" => "tag3" }
              ]
            }
          end
          it { is_expected.to eq expected }
        end
      end
    end
  end

  describe ".nest_keys" do
    subject { Zenform::ConfigParser::CSVParser.send :nest_keys, row }
    let(:row) do
      {
        "conditions.all" => [],
        "conditions.any" => []
      }
    end
    let(:expected) do
      {
        "conditions" => {
          "all" => [],
          "any" => []
        }
      }
    end
    it { is_expected.to eq expected }
  end
end
