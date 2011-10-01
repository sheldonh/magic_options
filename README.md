magic_options
-------------

MagicOptions is a ruby module that provides mechanisms for splatting
an options hash into an object's instance variables, typically during
object initialization.  Each key is taken as the name of an instance
variable, to which the associated value is assigned.

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

Written in colaboration with [@rorymckinley][c1]

[c1]: http://twitter.com/#!/rorymckinley

