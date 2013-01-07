describe Econfig::YAML do
  let(:backend) { Econfig::YAML.new }
  describe "#get" do
    it "fetches option from yaml config file" do
      backend.get("quox").should == "baz"
    end
  end
end
