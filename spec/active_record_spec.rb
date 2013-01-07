require "active_record"

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

ActiveRecord::Base.connection.create_table :econfig_options do |t|
  t.string :key, :null => false
  t.string :value
end

require "econfig/active_record"

describe Econfig::ActiveRecord do
  let(:backend) { Econfig::ActiveRecord.new }
  around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
  describe "#get" do
    it "fetches a previously set option" do
      backend.set("foo", "bar")
      backend.get("foo").should == "bar"
    end

    it "fetches a previously persisted option" do
      Econfig::ActiveRecord::Option.create!(:key => "foo", :value => "bar")
      backend.get("foo").should == "bar"
    end

    it "returns nil if option is not set" do
      backend.get("foo").should be_nil
    end
  end

  describe "#set" do
    it "persists keys to database" do
      backend.set("foo", "bar")
      Econfig::ActiveRecord::Option.find_by_key!("foo").value.should == "bar"
    end
  end
end
