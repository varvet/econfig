describe Econfig::Configuration do
  let(:collection) { Econfig::BackendCollection.new }
  let(:memory) { double("memory") }
  let(:yaml) { double("yaml") }

  describe "#[]" do
    it "retrieves a backend" do
      collection.add :memory, memory
      collection[:memory].should equal(memory)
    end
  end

  describe "#add" do
    it "adds a new backend at the top" do
      collection.add :memory, memory
      collection.add :memory, yaml
      collection.list.should eq([yaml, memory])
    end
  end

  describe "#insert_before" do
    it "adds a new before the given backend" do
      collection.add :foo, :foo
      collection.add :baz, :baz
      collection.add :quox, :quox
      collection.insert_before :baz, :memory, memory
      collection.list.should eq([:quox, memory, :baz, :foo])
    end
  end

  describe "#insert_after" do
    it "adds a new after the given backend" do
      collection.add :foo, :foo
      collection.add :baz, :baz
      collection.add :quox, :quox
      collection.insert_after :baz, :memory, memory
      collection.list.should eq([:quox, :baz, memory, :foo])
    end
  end

  describe "#delete" do
    it "removes the given backend" do
      collection.add :memory, memory
      collection.delete :memory
      collection[:memory].should be_nil
    end
  end
end
