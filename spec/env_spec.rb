describe Econfig::ENV do
  let(:backend) { Econfig::ENV.new }

  before do
    ENV["FOO_BAR"] = "monkey"
  end

  describe "#keys" do
    it "is not supported because it would return a lot of junk" do
      backend.respond_to?(:keys).should be_falsy
    end
  end

  describe "#has_key?" do
    it "returns true if key exists" do
      backend.has_key?("foo_bar").should eq(true)
    end

    it "returns false if key is not set" do
      backend.has_key?("does_not_exist").should eq(false)
    end
  end

  describe "#get" do
    it "fetches option from environment variables" do
      backend.get("foo_bar").should == "monkey"
    end

    it "returns nil when not set" do
      backend.get("does_not_exist").should == nil
    end
  end
end
