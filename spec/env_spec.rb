describe Econfig::ENV do
  let(:backend) { Econfig::ENV.new }
  describe "#get" do
    it "fetches option from environment variables" do
      ENV["FOO_BAR"] = "monkey"
      backend.get("foo_bar").should == "monkey"
    end
  end
end
