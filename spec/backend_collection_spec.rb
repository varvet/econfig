describe Econfig::Configuration do
  let(:collection) { Econfig::BackendCollection.new }
  let(:memory) { double("memory") }
  let(:yaml) { double("yaml") }

  describe "#[]" do
    it "retrieves a backend" do
      collection.push :memory, memory
      collection[:memory].should equal(memory)
    end
  end

  describe "#each" do
    it "can be called without a block to receive an enumerator" do
      collection.push :memory, memory
      collection.each.take(1).should eq([memory])
    end
  end

  describe "#push" do
    it "adds a new backend at the bottom" do
      collection.push :memory, memory
      collection.push :yaml, yaml
      collection.to_a.should eq([memory, yaml])
    end

    it "is aliased as `use`" do
      collection.use :memory, memory
      collection.use :yaml, yaml
      collection.to_a.should eq([memory, yaml])
    end

    it "raises an error if backend already exist" do
      collection.push :memory, memory
      expect { collection.push :memory, yaml }.to raise_error(KeyError, "memory is already set")
    end
  end

  describe "#unshift" do
    it "adds a new backend at the top" do
      collection.unshift :memory, memory
      collection.unshift :yaml, yaml
      collection.to_a.should eq([yaml, memory])
    end

    it "raises an error if backend already exist" do
      collection.unshift :memory, memory
      expect { collection.unshift :memory, yaml }.to raise_error(KeyError, "memory is already set")
    end
  end

  describe "#insert_before" do
    it "adds a new before the given backend" do
      collection.push :quox, :quox
      collection.push :baz, :baz
      collection.push :foo, :foo
      collection.insert_before :baz, :memory, memory
      collection.to_a.should eq([:quox, memory, :baz, :foo])
    end

    it "raises an error if the backend does not exist" do
      expect { collection.insert_before :baz, :memory, memory }.to raise_error(KeyError, /baz is not set/)
    end

    it "raises an error if the backend already exists" do
      collection.push :foo, :foo
      expect { collection.insert_before :foo, :foo, memory }.to raise_error(KeyError, /foo is already set/)
    end
  end

  describe "#insert_after" do
    it "adds a new after the given backend" do
      collection.push :quox, :quox
      collection.push :baz, :baz
      collection.push :foo, :foo
      collection.insert_after :baz, :memory, memory
      collection.to_a.should eq([:quox, :baz, memory, :foo])
    end

    it "raises an error if the backend does not exist" do
      expect { collection.insert_after :baz, :memory, memory }.to raise_error(KeyError, /baz is not set/)
    end

    it "raises an error if the backend already exists" do
      collection.push :foo, :foo
      expect { collection.insert_after :foo, :foo, memory }.to raise_error(KeyError, /foo is already set/)
    end
  end

  describe "#delete" do
    it "removes the given backend" do
      collection.push :memory, memory
      collection.delete :memory
      collection[:memory].should be_nil
    end

    it "raises an error if the backend does not exist" do
      expect { collection.delete :redis }.to raise_error(KeyError, /redis is not set/)
    end
  end
end
