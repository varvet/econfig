require "yaml"

describe Econfig::YAML do
  let(:backend) { Econfig::YAML.new }
  describe "#get" do
    it "fetches option from yaml config file" do
      backend.get("quox").should == "baz"
    end

    it "returns nil when the option does not exist" do
      backend.get("does_not_exist").should be_nil
    end

    it "returns nil when there is no config file" do
      backend = Econfig::YAML.new("/does/not/exist")
      backend.get("does_not_exist").should be_nil
    end
  end

  describe "#reload" do
    let(:backend) { Econfig::YAML.new("config/reload.yml") }
    let(:path) { File.expand_path("config/reload.yml", Econfig.root) }
    let(:original_hash) { { "test" => { "quox" => "baz" } } }
    let(:new_hash) { { "test" => { "quox" => "foo", "not_yet" => "now" } } }

    before { File.open(path, "w+") { |f| f.write(original_hash.to_yaml) } }
    after { File.open(path, "w+") { |f| f.write(original_hash.to_yaml) } }

    it "reloads the YAML file from disk" do
      File.open(path, "w+") { |f| f.write(new_hash.to_yaml) }
      backend.reload

      backend.get("quox").should == "foo"
      backend.get("not_yet").should == "now"
    end
  end

  describe "#name" do
    it "returns the filename without path" do
      backend.name.should eq "app"
    end
  end
end
