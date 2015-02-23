describe Econfig::YAML do
  let(:backend) { Econfig::YAML.new("config/app.yml") }

  describe "#has_key?" do
    it "returns true if option exists" do
      expect(backend.has_key?("quox")).to eq(true)
    end

    it "returns false when the key does not exist" do
      expect(backend.has_key?("does_not_exist")).to eq(false)
    end

    it "returns false when there is no config file" do
      backend = Econfig::YAML.new("/does/not/exist")
      expect(backend.has_key?("does_not_exist")).to eq(false)
    end
  end

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

    it "evaluates the YAML config as ERB" do
      with_env do
        ENV['ECONFIG_EXAMPLE'] = "onment"
        backend.get("envir").should == "onment"
      end
    end

    def with_env(&block)
      original = ENV.to_hash
      yield if block_given?
    ensure
      ENV.replace(original)
    end
  end
end
