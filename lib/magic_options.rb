require "magic_options/version"

module MagicOptions

  def magic_options(options, config = {})
    magic_options_validate(options, config)
    options.each do |option, value|
      instance_variable_set "@#{option}", value
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    attr_accessor :magic_options_config

    def magic_initialize(config = {})
      self.magic_options_config = config
      class_eval %{
        def initialize(options = {})
          magic_options(options, self.class.magic_options_config)
        end
      }
    end

  end

private

  def magic_options_validate(options, config)
    if config[:only] == :respond_to?
      if unknown = options.keys.detect { |option| !respond_to?(option) }
        raise ArgumentError, "Unknown option #{unknown} in new #{self.class}"
      end
    elsif config[:only]
      only = [config[:only], config[:require]].flatten.compact
      if unknown = options.keys.detect { |option| !only.include?(option) }
        raise ArgumentError, "Unknown option #{unknown} in new #{self.class}"
      end
    end
    if (required = [config[:require]].flatten.compact).size > 0
      if missing = required.detect { |requirement| !options.keys.include?(requirement) }
        raise ArgumentError, "Missing option #{missing} in new #{self.class}"
      end
    end
  end

end
