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
end
