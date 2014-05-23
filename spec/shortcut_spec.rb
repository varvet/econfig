describe Econfig::Shortcut do
  let(:mod) { Module.new }
  before { mod.extend Econfig::Shortcut }

  describe "#config" do
    it "should be the econfig instance" do
      mod.config.should equal(Econfig.instance)
    end
  end
end
