describe Econfig::Configuration do
  let(:backend) { double("backend") }
  let(:other_backend) { double("other backend") }
  let(:config) { Econfig::Configuration.new }

  before do
    config.backends.push(:one, backend)
    config.backends.push(:other, other_backend)
  end

  describe "#[]" do
    it "returns response from first backend" do
      backend.stub(:has_key?).with("foobar").and_return(true)
      backend.stub(:get).with("foobar").and_return("elephant")
      config["foobar"].should == "elephant"
    end

    it "casts key to string" do
      backend.stub(:has_key?).with("foobar").and_return(true)
      backend.stub(:get).with("foobar").and_return("elephant")
      config[:foobar].should == "elephant"
    end

    it "tries multiple backends until it finds a response" do
      backend.stub(:has_key?).with("foobar").and_return(false)
      other_backend.stub(:has_key?).with("foobar").and_return(true)
      other_backend.stub(:get).with("foobar").and_return("elephant")
      config["foobar"].should == "elephant"
    end

    it "tries multiple backends which yield from get until it finds one which doesn't" do
      backend.stub(:get).with("foobar").and_yield
      other_backend.stub(:get).with("foobar").and_return("elephant")
      config["foobar"].should == "elephant"
    end

    it "returns nil if the key can't be found in any backend" do
      backend.stub(:has_key?).with("foobar").and_return(false)
      other_backend.stub(:has_key?).with("foobar").and_return(false)
      config["foobar"].should == nil
    end
  end

  describe "#[]=" do
    it "sets response on given backend" do
      backend.should_receive(:set).with("foobar", "elephant")
      config[:one, "foobar"] = "elephant"
    end

    it "casts keys to string" do
      backend.should_receive(:set).with("foobar", "elephant")
      config[:one, :foobar] = "elephant"
    end

    it "sets response on default backend if default backend is set" do
      config.default_write_backend = :other
      other_backend.should_receive(:set).with("foobar", "elephant")
      config["foobar"] = "elephant"
    end

    it "raises an error if no backend given and no default backend is set" do
      config.default_write_backend = nil
      expect { config["foobar"] = "elephant" }.to raise_error(ArgumentError, "no backend given")
    end

    it "raises an error if the backend does not exist" do
      expect { config[:does_not_exist, "foobar"] = "elephant" }.to raise_error(KeyError, "does_not_exist is not set")
    end
  end

  describe "#fetch" do
    it "returns response from first backend" do
      backend.stub(:has_key?).with("foobar").and_return(true)
      backend.stub(:get).with("foobar").and_return("elephant")
      config.fetch("foobar").should == "elephant"
    end

    it "tries multiple backends until it finds a response" do
      backend.stub(:has_key?).with("foobar").and_return(false)
      other_backend.stub(:has_key?).with("foobar").and_return(true)
      other_backend.stub(:get).with("foobar").and_return("elephant")
      config.fetch("foobar").should == "elephant"
    end

    it "raises error if the key can't be found in any backend" do
      backend.stub(:has_key?).with("foobar").and_return(false)
      other_backend.stub(:has_key?).with("foobar").and_return(false)
      expect { config.fetch("foobar") }.to raise_error(Econfig::NotFound)
    end

    it "allows falsy responses" do
      backend.stub(:has_key?).with("foobar").and_return(false)
      other_backend.stub(:has_key?).with("foobar").and_return(true)
      other_backend.stub(:get).with("foobar").and_return(false)
      config.fetch("foobar").should == false
    end
  end

  describe "#method_missing" do
    after do
      ENV["ECONFIG_PERMISSIVE"] = nil
    end

    it "calls fetch for normal methods" do
      backend.stub(:has_key?).with("foobar").and_return(true)
      backend.stub(:get).with("foobar").and_return("elephant")
      config.foobar.should == "elephant"
    end

    it "raises error if the key can't be found in any backend" do
      backend.stub(:has_key?).with("foobar").and_return(false)
      other_backend.stub(:has_key?).with("foobar").and_return(false)
      expect { config.foobar }.to raise_error(Econfig::NotFound)
    end

    it "returns nil if environment variable bypass is set" do
      ENV["ECONFIG_PERMISSIVE"] = "true"
      backend.stub(:has_key?).with("foobar").and_return(false)
      other_backend.stub(:has_key?).with("foobar").and_return(false)
      config.foobar.should be_nil
    end

    it "allows falsy responses" do
      backend.stub(:has_key?).with("foobar").and_return(false)
      other_backend.stub(:has_key?).with("foobar").and_return(true)
      other_backend.stub(:get).with("foobar").and_return(false)
      config.foobar.should == false
    end

    it "raises NoMethodError for bang methods" do
      expect { config.foobar! }.to raise_error(NoMethodError)
    end

    it "raises NoMethodError for query methods" do
      expect { config.foobar? }.to raise_error(NoMethodError)
    end

    it "raises NoMethodError for setter methods" do
      expect { config.foobar = "bar" }.to raise_error(NoMethodError)
    end

    it "raises an error when giving arguments to a getter" do
      expect { config.foobar "Hey" }.to raise_error(ArgumentError, "too many arguments (1 for 0)")
    end
  end

  describe "#respond_to?" do
    it "return true for normal methods" do
      config.should respond_to(:foobar)
    end

    it "return false for bang methods" do
      config.should_not respond_to(:foobar!)
    end

    it "return false for query methods" do
      config.should_not respond_to(:foobar?)
    end

    it "return false for assignment methods" do
      config.should_not respond_to(:foobar=)
    end
  end
end
