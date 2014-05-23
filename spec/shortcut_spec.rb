describe Econfig::Shortcut do
  let(:mod) { Module.new }
  before { mod.extend Econfig::Shortcut }

  describe "#method_missing" do
    it "proxies getters to the Econfig instance" do
      Econfig.instance.should_receive(:get).with("foobar").and_return("elephant")
      mod.config.foobar.should == "elephant"
    end

    it "proxies bang methods to the Econfig instance" do
      Econfig.instance.should_receive(:get!).with("foobar").and_return("elephant")
      mod.config.foobar!.should == "elephant"
    end
  end
end
