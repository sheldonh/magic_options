require "magic_options/version"

module MagicOptions

  def initialize(options = {})
    options.each do |option, value|
      magic_options_validate(option)
      instance_variable_set "@#{option}".to_sym, value
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

  def magic_options_validate(option)
    return unless allowed = self.class.magic_options_allowed
    if allowed[0] == :accessors
      return if respond_to?(option)
    else
      return if allowed.include?(option)
    end
    raise ArgumentError, "Unknown option #{option} in new #{self.class}"
  end

end
