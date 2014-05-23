require "redis"
require "econfig/redis"

describe Econfig::Redis do
  let(:redis) { Redis.new(:databse => "econfig_test") }
  let(:backend) { Econfig::Redis.new(redis) }
  after do |example|
    redis.flushdb
  end
  describe "#get" do
    it "fetches a previously set option" do
      backend.set("foo", "bar")
      backend.get("foo").should == "bar"
    end

    it "fetches a previously persisted option" do
      redis.set("foo", "bar")
      backend.get("foo").should == "bar"
    end

    it "returns nil if option is not set" do
      backend.get("foo").should be_nil
    end
  end

  describe "#set" do
    it "persists keys to database" do
      backend.set("foo", "bar")
      redis.get("foo").should == "bar"
    end
  end
end
