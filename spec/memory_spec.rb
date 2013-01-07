describe Econfig::Memory do
  let(:backend) { Econfig::Memory.new }
  describe "#get" do
    it "fetches a previously set option" do
      backend.set("foo", "bar")
      backend.get("foo").should == "bar"
    end
  end
end
