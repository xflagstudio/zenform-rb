RSpec.describe Zenform::ConfigParser::CSVParser::ValueConverter do
  describe ".create" do
    subject { CSV.parse(csv, headers: true, converters: converter).map(&:to_h) }
    let(:converter) { Zenform::ConfigParser::CSVParser::ValueConverter.create file_path, fields }
    let(:file_path) { "/path/to/csv" }
    let(:fields) do
      [
        {
          "name" => "title"
        },
        {
          "name" => "custom_field_options.names",
          "type" => "json"
        },
        {
          "name" => "visible_in_portal",
          "type" => "bool"
        },
        {
          "name" => "position",
          "type" => "int"
        },
      ]
    end
    context "invalid form" do
      let(:csv) do
<<TEXT
title,custom_field_options.names,visible_in_portal,position
title1,invalid form for json parser,TRUE,0
TEXT
      end
      it "raises Zenform::ParseError" do
        expect { subject }.to raise_error Zenform::ParseError
      end
    end
    context "invalid form" do
      let(:csv) do
<<TEXT
title,custom_field_options.names,visible_in_portal,position
title1,"[""a"",""b""]",TRUE,0
TEXT
      end
      let(:expected) do
        [
          { "title" => "title1", "custom_field_options.names" => ["a", "b"], "visible_in_portal" => true, "position" => 0 }
        ]
      end
      it { is_expected.to eq expected }
    end
  end

  describe ".parse_as_json" do
    subject { Zenform::ConfigParser::CSVParser::ValueConverter.send :parse_as_json, value }
    context "invalid" do
      let(:value) { "[1,2,," }
      it "raises JSON::ParserError" do
        expect { subject }.to raise_error JSON::ParserError
      end
    end
    context "valid" do
      context "nil" do
        let(:value) { nil }
        it { is_expected.to be_nil }
      end
      context "empty" do
        let(:value) { "" }
        it { is_expected.to be_nil }
      end
      context "not empty" do
        let(:value) { "[1,2,3]" }
        it { is_expected.to eq [1,2,3] }
      end
    end
  end

  describe ".parse_as_string" do
    subject { Zenform::ConfigParser::CSVParser::ValueConverter.send :parse_as_string, value }
    context "nil" do
      let(:value) { nil }
      it { is_expected.to eq "" }
    end
    context "string" do
      let(:value) { "hoge" }
      it { is_expected.to eq value }
    end
  end

  describe ".parse_as_bool" do
    subject { Zenform::ConfigParser::CSVParser::ValueConverter.send :parse_as_bool, value }
    context "invalid" do
      let(:value) { "tr" }
      it "raises Zenform::TypeConversionError" do
        expect { subject }.to raise_error Zenform::TypeConversionError
      end
    end
    context "valid" do
      context "TRUE" do
        let(:value) { "TRUE" }
        it { is_expected.to eq true }
      end
      context "FALSE" do
        let(:value) { "FALSE" }
        it { is_expected.to eq false }
      end
    end
  end

  describe ".parse_as_int" do
    subject { Zenform::ConfigParser::CSVParser::ValueConverter.send :parse_as_int, value }
    context "invalid" do
      context "empty" do
        let(:value) { "" }
        it "raises Zenform::TypeConversionError" do
          expect { subject }.to raise_error Zenform::TypeConversionError
        end
      end
      context "inlcude not number" do
        let(:value) { "123yen" }
        it "raises Zenform::TypeConversionError" do
          expect { subject }.to raise_error Zenform::TypeConversionError
        end
      end
    end
    context "valid" do
      let(:value) { "123" }
      it { is_expected.to eq 123 }
    end
  end
end
