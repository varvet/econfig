describe Econfig::Memory do
  let(:backend) { Econfig::Memory.new }

  describe "#has_key?" do
    it "returns true if key exists" do
      backend.set("foo", "bar")
      backend.has_key?("foo").should eq(true)
    end

    it "returns false if key is not set" do
      backend.has_key?("foo").should eq(false)
    end
  end

  describe "#get" do
    it "fetches a previously set option" do
      backend.set("foo", "bar")
      backend.get("foo").should == "bar"
    end
  end
end
