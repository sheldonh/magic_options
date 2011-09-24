Feature: magic_options instance method
  To save time and improve readability of Ruby object initializers
  developers
  want to splat options hashes into instance variables.

  Scenario: no limits
    Given a class
    And it mixes in MagicOptions
    And its initialize method calls magic_options(options)
    When it receives new(:name => 'Daisy', :color => :brown)
    Then the instance has @name set to 'Daisy'
    And the instance has @color set to :brown

  Scenario: honouring an :only limit
    Given a class
    And it mixes in MagicOptions
    And its initialize method calls magic_options(options, :only => [:name, :color])
    When it receives new(:name => 'Daisy', :color => :brown)
    Then the instance has @name set to 'Daisy'
    And the instance has @color set to :brown

  Scenario: violating an :only limit
    Given a class
    And it mixes in MagicOptions
    And its initialize method calls magic_options(options, :only => [:name, :color])
    When it receives new(:name => 'Daisy', :gender => :female)
    Then an ArgumentError is raised
    And the error message is "Unknown option gender in new Cow"

  Scenario: honouring a :require limit
    Given a class
    And it mixes in MagicOptions
    And its initialize method calls magic_options(options, :require => :name)
    When it receives new(:name => 'Daisy', :color => :brown)
    Then the instance has @name set to 'Daisy'
    And the instance has @color set to :brown

  Scenario: violating a :require limit
    Given a class
    And it mixes in MagicOptions
    And its initialize method calls magic_options(options, :require => :name)
    When it receives new(:gender => :female)
    Then an ArgumentError is raised
    And the error message is "Missing option name in new Cow"

  Scenario: a :require limit satisfies an :only limit
    Given a class
    And it mixes in MagicOptions
    And its initialize method calls magic_options(options, :only => :color, :require => :name)
    When it receives new(:name => 'Daisy', :color => :brown)
    Then the instance has @name set to 'Daisy'
    And the instance has @color set to :brown

  Scenario: an :only limit doesn't satisfy a :require limit
    Given a class
    And it mixes in MagicOptions
    And its initialize method calls magic_options(options, :only => :color, :require => :name)
    When it receives new(:color => :brown)
    Then an ArgumentError is raised
    And the error message is "Missing option name in new Cow"

