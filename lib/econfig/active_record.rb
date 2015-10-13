require "active_record"

module Econfig
  class ActiveRecord
    MISSING_TABLE_WARNING = <<-WARNING.gsub(/^ */, "")
      =======================================================================
      Econfig table not found. Please add the configuration table by running:

      rails generate econfig:migration
      rake db:migrate
      =======================================================================
    WARNING

    class Option < ::ActiveRecord::Base
      attr_accessible :key, :value rescue nil
      self.table_name = "econfig_options"
      validates_uniqueness_of :key
      validates_presence_of :key
    end

    def keys
      Set.new(Option.pluck(:key))
    rescue ::ActiveRecord::StatementInvalid
      warn MISSING_TABLE_WARNING
      Set.new([])
    end

    def get(key)
      if option = Option.find_by_key(key)
        option.value
      else
        yield if block_given?
      end
    rescue ::ActiveRecord::StatementInvalid
      warn MISSING_TABLE_WARNING
    end

    def set(key, value)
      option = Option.where(:key => key).first_or_initialize
      option.update_attributes!(:value => value)
    rescue ::ActiveRecord::StatementInvalid
      warn MISSING_TABLE_WARNING
    end
  end
end
