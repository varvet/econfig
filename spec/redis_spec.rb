require "redis"
require "econfig/redis"

describe Econfig::Redis do
  let(:redis) { Redis.new(:databse => "econfig_test") }
  let(:backend) { Econfig::Redis.new(redis) }
  after do |example|
    redis.flushdb
  end

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
