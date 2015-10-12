# encoding: utf-8
module Econfig
  class BackendCollection
    include Enumerable

    def initialize
      @backends = []
    end

    def [](name)
      pair = @backends.assoc(name)
      pair.last if pair
    end

    def each
      if block_given?
        @backends.each { |(name, backend)| yield backend }
      else
        enum_for { @backends.length }
      end
    end

    def push(name, backend)
      exists‽(name)
      @backends.push([name, backend])
    end
    alias_method :use, :push

    def unshift(name, backend)
      exists‽(name)
      @backends.unshift([name, backend])
    end

    def insert_before(other, name, backend)
      exists‽(name)
      @backends.insert(index_of!(other), [name, backend])
    end

    def insert_after(other, name, backend)
      exists‽(name)
      @backends.insert(index_of!(other) + 1, [name, backend])
    end

    def delete(name)
      @backends.delete_at(index_of!(name))
    end

    def get(key)
      @backends.each do |(name, backend)|
        has_key = true

        if backend.respond_to?(:has_key?)
          has_key = backend.has_key?(key)
          value = backend.get(key) if has_key
        else
          value = backend.get(key) { has_key = false }
        end

        has_key or next
        return value
      end

      yield if block_given?
    end

  private

    def exists‽(name)
      raise KeyError, "#{name} is already set" if index_of(name)
    end

    def index_of!(name)
      index_of(name) or raise KeyError, "#{name} is not set"
    end

    def index_of(name)
      @backends.index(@backends.assoc(name))
    end
  end
end
