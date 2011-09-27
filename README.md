magic_options
-------------

MagicOptions is a ruby module that provides mechanisms for splatting
an options hash into an object's instance variables.  Each key is taken
as the name of an instance variable, to which the associated value is
assigned.

Version 1.0.0 broke compatibility with previous versions, in the
interests of being useful in subclasses and in initializers that take
more than just an options hash.

Examples
--------

```ruby
require 'rubygems'
require 'magic_options'

class Gullible

  include MagicOptions

  magic_initialize

end

Gullible.new :accepts => "anything"
 => #<Gullible:0x7f77e407fdb0 @accepts="anything">

class Cow

  include MagicOptions

  magic_initialize :only => :respond_to?

  attr_accessor :color, :gender

end

Cow.new :color => "brown", :gender => "female"
 => #<Cow:0x7f77e409a6d8 @gender="female", @color="brown">
Cow.new :color => "brown", :gender => "female", :wheels => 4
 => ArgumentError: Unknown option wheels for new Cow

class Professor

  include MagicOptions

  def initialize(name, options = {})
    magic_options options, :only => [:iq, :hairstyle]
  end

end

Professor.new :hair_style => :einsteinian
 => #<Professor:0x7f77e406d980 @hair_style=:einsteinian>
Professor.new :does_not_take => :anything
 => ArgumentError: Unknown option does_not_take for new Professor
```

Documentation
-------------

Working code first.  For now, here are the specs for the magic_options
method:

```
MagicOptions#magic_options(options, config = {})
  Given class Cow mixes in MagicOptions
    When Cow#initialize(options) calls magic_options(options)
      Then Cow.new(:name => 'Daisy', :color => :brown)
        sets @name to 'Daisy'
        sets @color to :brown
    When Cow#initialize(options) calls magic_options(options, :only => [:name, :color])
      Then Cow.new(:name => 'Daisy', :color => :brown)
        sets @name to 'Daisy'
        sets @color to :brown
      Then Cow.new(:name => 'Daisy', :gender => :female)
        raises an ArgumentError
        reports the offending class and the unknown option
    When Cow#initialize(options) calls magic_options(options, :require => :name)
      Then Cow.new(:name => 'Daisy', :color => :brown)
        sets @name to 'Daisy'
        sets @color to :brown
      Then Cow.new(:color => :brown)
        raises an ArgumentError
        reports the offending class and the missing option
    When Cow#initialize(options) calls magic_options(options, :only => :color, :require => :name)
      Then Cow.new(:name => 'Daisy', :color => :brown)
        sets @name to 'Daisy'
        sets @color to :brown
      Then Cow.new(:color => :brown)
        raises an ArgumentError
        reports the offending class and the missing option
```

MagicOptions::ClassMethods#magic_initialize(config = {}) creates an
initialize method that works like this:

```ruby
def initialize(options = {})
  magic_options(options, config)
end
```

Obtaining
---------

<https://github.com/sheldonh/magic_options>

To install from rubygems.org:

```
gem install magic_options
```

To fetch the source from github.com:

```
git clone git://github.com/sheldonh/magic_options.git
```

Credits
-------

Pair programmed with [@rorymckinley][c1]

[c1]: http://twitter.com/#!/rorymckinley

