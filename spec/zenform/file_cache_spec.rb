RSpec.describe Zenform::FileCache do
  let(:project_path) { File.expand_path "../fixtures/", File.dirname(__FILE__) }
  let(:cache_path)   { File.expand_path file_name, project_path }
  let(:file_name)    { Zenform::FileCache::FILENAME % { content_name: content_name } }
  let(:content_name) { "test" }

  after do
    File.delete cache_path if File.exists? cache_path
  end

  describe ".read" do
    subject { Zenform::FileCache.read project_path, content_name }
    context "no cache file" do
      it { is_expected.to be_nil }
    end
    context "cache file" do
      let(:data) { { "timestamp" => Time.now.to_i, "ticket_fields" => [] } }
      before do
        File.open(cache_path, "w") { |f| f.puts data.to_json }
      end
      it { is_expected.to eq data }
    end
  end

  describe ".write" do
    subject { Zenform::FileCache.write project_path, content_name, data }
    let(:data) { { "timestamp" => Time.now.to_i, "ticket_fields" => [] } }
    it "makes file" do
      expect { subject }.to change { File.exists? cache_path }.to(true)
    end
    it "write json data" do
      subject
      expect(Zenform::FileCache.read(project_path, content_name)).to eq data
    end
  end
end
