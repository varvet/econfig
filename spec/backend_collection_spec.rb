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

  describe "#each" do
    it "can be called without a block to receive an enumerator" do
      collection.add :memory, memory
      collection.each.take(1).should eq([memory])
    end
  end

  describe "#add" do
    it "adds a new backend at the top" do
      collection.add :memory, memory
      collection.add :yaml, yaml
      collection.to_a.should eq([yaml, memory])
    end

    it "raises an error if backend already exist" do
      collection.add :memory, memory
      expect { collection.add :memory, yaml }.to raise_error(KeyError, "memory is already set")
    end
  end

  describe "#insert_before" do
    it "adds a new before the given backend" do
      collection.add :foo, :foo
      collection.add :baz, :baz
      collection.add :quox, :quox
      collection.insert_before :baz, :memory, memory
      collection.to_a.should eq([:quox, memory, :baz, :foo])
    end

    it "raises an error if the backend does not exist" do
      expect { collection.insert_before :baz, :memory, memory }.to raise_error(KeyError, /baz is not set/)
    end

    it "raises an error if the backend already exists" do
      collection.add :foo, :foo
      expect { collection.insert_before :foo, :foo, memory }.to raise_error(KeyError, /foo is already set/)
    end
  end

  describe "#insert_after" do
    it "adds a new after the given backend" do
      collection.add :foo, :foo
      collection.add :baz, :baz
      collection.add :quox, :quox
      collection.insert_after :baz, :memory, memory
      collection.to_a.should eq([:quox, :baz, memory, :foo])
    end

    it "raises an error if the backend does not exist" do
      expect { collection.insert_after :baz, :memory, memory }.to raise_error(KeyError, /baz is not set/)
    end

    it "raises an error if the backend already exists" do
      collection.add :foo, :foo
      expect { collection.insert_after :foo, :foo, memory }.to raise_error(KeyError, /foo is already set/)
    end
  end

  describe "#delete" do
    it "removes the given backend" do
      collection.add :memory, memory
      collection.delete :memory
      collection[:memory].should be_nil
    end

    it "raises an error if the backend does not exist" do
      expect { collection.delete :redis }.to raise_error(KeyError, /redis is not set/)
    end
  end
end
