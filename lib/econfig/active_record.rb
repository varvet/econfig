module Econfig
  class ActiveRecord
    class Option < ::ActiveRecord::Base
      attr_accessible :key, :value rescue nil
      self.table_name = "econfig_options"
      validates_uniqueness_of :key
      validates_presence_of :key
    end

    def keys
      Set.new(Option.pluck(:key))
    end

    def get(key)
      if option = Option.find_by_key(key)
        option.value
      else
        yield if block_given?
      end
    end

    def set(key, value)
      option = Option.where(:key => key).first_or_initialize
      option.update_attributes!(:value => value)
    end
  end
end
