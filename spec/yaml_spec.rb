describe Econfig::YAML do
  let(:backend) { Econfig::YAML.new("config/app.yml").tap(&:init) }
  describe "#get" do
    it "fetches option from yaml config file" do
      backend.get("quox").should == "baz"
    end

    it "returns nil when the option does not exist" do
      backend.get("does_not_exist").should be_nil
    end

    it "returns nil when there is no config file" do
      backend = Econfig::YAML.new("/does/not/exist").tap(&:init)
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
