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

    attr_accessor :magic_options_allowed

    def magic_options(*allowed)
      self.magic_options_allowed = allowed
    end

  end

private

  def magic_options_validate(options, config)
    return if config.empty?
    if only = [config[:only], config[:require]].flatten.compact
      if unknown = options.keys.detect { |option| !only.include?(option) }
        raise ArgumentError, "Unknown option #{unknown} in new #{self.class}"
      end
    end
    if required = [config[:require]].flatten.compact
      if missing = required.detect { |requirement| !options.keys.include?(requirement) }
        raise ArgumentError, "Missing option #{missing} in new #{self.class}"
      end
    end
  end

end
