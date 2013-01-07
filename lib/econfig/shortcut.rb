module Econfig
  module Shortcut
    def method_missing(name, *args)
      Econfig.instance.send(name, *args)
    end

    def respond_to?(*)
      true
    end
  end
end
