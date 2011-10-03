require "magic_options/version"

# MagicOptions is an unobtrusive ruby module for splatting an options
# hash into an object's instance variables, typically during object
# initialization.  Each key is taken as the name of an instance variable,
# to which the associated value is assigned.
#
# The following code demonstrates the #magic_options instance method:
#
# <tt>
#   class Cow
#     include MagicOptions
#
#     def initialize(name, options = {})
#       @name = name.capitalize
#       magic_options options, :only => [:color, :gender]
#     end
#   end
#
#   Cow.new('Daisy', :color => 'brown', :gender => 'female', :some => 'rubbish')
#   # => #<Cow:0x000000015d02b8 @color="brown", @gender="female", @name="Daisy">
# </tt>
#
# If the +initialize+ method need do nothing more than handle magic options, it
# may be defined with MagicOptions::ClassMethods#magic_initialize instead.
#
module MagicOptions

  # Assign every value from the options hash into an instance variable named after the associated key.
  # The optional config hash may impose constraints on this behaviour as follows:
  #
  # [+:only+]
  #   Specify the only options that may be assigned.  The special value +:respond_to?+ specifies that options
  #   are assigned if they name a method on the instance.
  #
  # [+:require+]
  #   Specify options that must be passed.  Options specified in +:require+ do not need to be included in :+only+.
  #
  # [+:strict+]
  #   Specify that an +ArgumentError+ should be raised instead of ignoring unexpected options.  Defaults to false.
  #
  # Raises:
  #
  # [ArgumentError] when +:strict+ is true, +:only+ is specified and an unexpected option is passed
  # [ArgumentError] when +:require+ specifies one or more options that are not passed
  def magic_options(options, config = {})
    magic_options_validate options, config
    options.each do |option, value|
      instance_variable_set("@#{option}", value) if magic_options_wanted?(option, config)
    end
  end

  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
  end

  # When an object initializer need do nothing more than handle magic options,
  # it can be defined in terms of its magic options as follows:
  #
  # <tt>
  #   class Cow
  #     include MagicOptions
  #     magic_initialize :require => :name, :only => [:color, :gender]
  #   end
  #
  #   Cow.new(:name => 'Daisy', :color => 'brown', :gender => 'female')
  #   # => #<Cow:0x000000015d02b8 @color="brown", @gender="female", @name="Daisy">
  # </tt>
  #
  # If the +initialize+ method must be defined to handle other responsibilities,
  # magic options may be handled with MagicOptions#magic_options instead.
  #
  module ClassMethods

    # Class accessor used by #magic_initialize to store the +config+ hash it receives, to be
    # passed into MagicOptions#magic_options in the object initializer that #magic_initialize
    # defines.
    attr_accessor :magic_options_config

    # Defines an object initializer that takes an options hash and passes it to
    # MagicOptions#magic_options, along with the optional +config+ hash.
    #
    # This has the same effect as the following code:
    #
    # <tt>
    #   def initialize(options = {})
    #     magic_options(options, self.class.magic_options_config)
    #   end
    # </tt>
    #
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
    if config[:strict]
      options.keys.each do |option|
        raise ArgumentError, "Unknown option #{option} in new #{self.class}" unless magic_options_wanted?(option, config)
      end if config[:only] || config[:require]
    end
    if missing = magic_options_missing?(options, config)
      raise ArgumentError, "Missing option #{missing} in new #{self.class}"
    end
  end

  def magic_options_missing?(options, config) # :nodoc:
    if config[:require].is_a?(Enumerable)
      return config[:require].detect { |required| !options.include?(required) }
    elsif config[:require]
      return config[:require] unless options.include?(config[:require])
    end
  end

  def magic_options_wanted?(option, config) # :nodoc:
    return true if !config[:only] && !config[:require]
    return true if config[:only] == :respond_to? && respond_to?(option)
    return true if config[:only].is_a?(Enumerable) && config[:only].include?(option)
    return true if config[:only] == option
    return true if config[:require].is_a?(Enumerable) && config[:require].include?(option)
    return true if config[:require] == option
    false
  end

end
