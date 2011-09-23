magic_options
-------------

MagicOptions is a ruby module that provides an initialize method that takes an
optional hash of options.  Each key is taken as the name of an instance
variable, to which the associated value is assigned.

Example
-------

```ruby
require 'rubygems'
require 'magic_options'

Cow.new :color => "brown", :gender => "female"
 => #<Cow:0x7f77e409a6d8 @gender="female", @color="brown">
Cow.new :color => "brown", :gender => "female", :wheels => 4
 => ArgumentError: Unknown option wheels for new Cow

class Gullible

  include MagicOptions

end

Gullible.new :accepts => "anything"
 => #<Gullible:0x7f77e407fdb0 @accepts="anything">

class Professor

  include MagicOptions

  magic_options :iq, :hair_style

end

Professor.new :hair_style => :einsteinian
 => #<Professor:0x7f77e406d980 @hair_style=:einsteinian>
Professor.new :does_not_take => :anything
 => ArgumentError: Unknown option does_not_take for new Professor
```

Obtaining
---------

[https://github.com/sheldonh/magic_options]

Credits
-------

Pair programmed with [@rorymckinley][http://twitter.com/#!/rorymckinley]

