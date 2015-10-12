module Econfig
  class ActiveRecord
    class Option < ::ActiveRecord::Base
      attr_accessible :key, :value rescue nil
      self.table_name = "econfig_options"
      validates_uniqueness_of :key
      validates_presence_of :key
    end

    def has_key?(key)
      Option.where(key: key).exists?
    end

    def get(key)
      Option.find_by_key(key).try(:value)
    end

    def set(key, value)
      option = Option.where(:key => key).first_or_initialize
      option.update_attributes!(:value => value)
    end
  end
end
