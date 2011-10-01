require "magic_options/version"

# MagicOptions is a ruby module that provides mechanisms for splatting
# an options hash into an object's instance variables, typically during
# object initialization.  Each key is taken as the name of an instance
# variable, to which the associated value is assigned.
#
# For example:
#
# <tt>
#   class Cow
#     def initialize(name, options = {})
#       @name = name.capitalize
#       @color = color
#       @gender = gender
#     end
#   end
#
#   Cow.new('Daisy', :color => 'brown', :gender => 'female')
#   # => #<Cow:0x000000015d02b8 @color="brown", @gender="female", @name="Daisy">
# </tt>
#
# Here's how the same object initializer might be defined with MagicOptions:
#
# <tt>
#   class Cow
#     include MagicOptions
#
#     def initialize(name, options = {})
#       @name = name.capitalize
#       magic_options(options, :only => [:color, :gender])
#     end
#   end
# </tt>
#
# If your initialize method does nothing other than implement the magic options pattern,
# you can let MagicOptions::ClassMethods#magic_initialize define it for you instead.
#
module MagicOptions

  # Assign every value from the options hash into an instance variable named after the associated key.
  # The optional config hash may impose constraints on this behaviour as follows:
  #
  # [+:only+]
  #   Specify the only options that are allowed.  The special value +:respond_to?+ specifies that options
  #   are allowed if they name a method on the instance.
  #
  # [+:require+]
  #   Specify options that must be passed.  Options specified in +:require+ do not also need to be
  #   specified in +:only+.
  #
  # Raises:
  #
  # [ArgumentError] when +:only+ is specified and an option is passed that is not in +:only+ or +:require+
  # [ArgumentError] when +:require+ specifies one or more options that are not passed
  def magic_options(options, config = {})
    magic_options_validate(options, config)
    options.each do |option, value|
      instance_variable_set "@#{option}", value
    end
  end

  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
  end

  # When an object initializer need do nothing more than implement the magic options pattern,
  # it can be defined in terms of its magic options as follows:
  #
  # <tt>
  #   class Cow
  #     include MagicOptions
  #     magic_initialize(:require => :name, :only => [:color, :gender])
  #   end
  #
  #   Cow.new(:name => 'Daisy', :color => 'brown', :gender => 'female')
  #   # => #<Cow:0x000000015d02b8 @color="brown", @gender="female", @name="Daisy">
  # </tt>
  #
  # When the object initializer must do more than this (for example, if it must call +super+),
  # you can define it yourself in terms of MagicOptions#magic_options.
  #
  module ClassMethods

    # Class accessor used by #magic_initialize to store the +config+ hash it receives, to be
    # passed into MagicOptions#magic_options in the object initializer that #magic_initialize
    # defines.
    attr_accessor :magic_options_config

    # Defines an object initializer that takes an options hash and passes it to
    # MagicOptions#magic_options, along with the optional +config+ hash.
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

  def magic_options_validate(options, config) # :nodoc:
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
