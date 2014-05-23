module Econfig
  class BackendCollection
    def initialize
      @backends = []
    end

    def [](name)
      pair = @backends.assoc(name)
      pair.last if pair
    end

    def add(name, backend)
      @backends.unshift([name, backend])
    end

    def insert_before(other, name, backend)
      @backends.insert(index_of(other), [name, backend])
    end

    def insert_after(other, name, backend)
      @backends.insert(index_of(other) + 1, [name, backend])
    end

    def list
      @backends.map(&:last)
    end

    def delete(name)
      @backends.delete_at(index_of(name))
    end

  private

    def index_of(name)
      @backends.index(@backends.assoc(name))
    end
  end
end
