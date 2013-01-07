describe Econfig::Configuration do
  let(:backend) { stub }
  let(:other_backend) { stub }
  let(:config) { Econfig::Configuration.new }

  before { config.backends.push(backend, other_backend) }

  describe "#get" do
    it "returns response from first backend" do
      backend.stub(:get).with("foobar").and_return("elephant")
      config.get("foobar").should == "elephant"
    end

    it "tries multiple backends until it finds a response" do
      backend.stub(:get).with("foobar").and_return(nil)
      other_backend.stub(:get).with("foobar").and_return("elephant")
      config.get("foobar").should == "elephant"
    end

    it "returns nil if the key can't be found in any backend" do
      backend.stub(:get).with("foobar").and_return(nil)
      other_backend.stub(:get).with("foobar").and_return(nil)
      config.get("foobar").should == nil
    end
  end

  describe "#get!" do
    it "returns response from first backend" do
      backend.stub(:get).with("foobar").and_return("elephant")
      config.get!("foobar").should == "elephant"
    end

    it "tries multiple backends until it finds a response" do
      backend.stub(:get).with("foobar").and_return(nil)
      other_backend.stub(:get).with("foobar").and_return("elephant")
      config.get!("foobar").should == "elephant"
    end

    it "raises error if the key can't be found in any backend" do
      backend.stub(:get).with("foobar").and_return(nil)
      other_backend.stub(:get).with("foobar").and_return(nil)
      expect { config.get!("foobar") }.to raise_error(Econfig::NotFound)
    end
  end

  describe "#set" do
    it "sets response on first backend" do
      backend.should_receive(:set).with("foobar", "elephant")
      config.set("foobar", "elephant")
    end

    it "skips backends which don't have a set method" do
      other_backend.should_receive(:set).with("foobar", "elephant")
      config.set("foobar", "elephant")
    end

    it "does nothing when no backend has a setter method" do
      config.set("foobar", "elephant")
    end
  end

  describe "#method_missing" do
    it "calls get for normal methods" do
      config.should_receive(:get).with("foobar").and_return("elephant")
      config.foobar.should == "elephant"
    end

    it "calls get! for bang methods" do
      config.should_receive(:get!).with("foobar").and_return("elephant")
      config.foobar!.should == "elephant"
    end

    it "calls set for assignment methods" do
      config.should_receive(:set).with("foobar", "elephant")
      config.foobar = "elephant"
    end
  end
end
