require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'magic_options'

describe "MagicOptions#magic_options(options, config = {})" do

  before(:each) do
    begin; Object.send(:remove_const, :Cow); rescue; end
    class Cow
      include MagicOptions
    end
  end

  it "assigns values from the options hash to instance variables named by the keys in the hash" do
    class Cow
      def initialize(options = {}); magic_options(options); end
    end
    @cow = Cow.new(:name => 'Daisy')
    @cow.instance_variable_get('@name').should == 'Daisy'
  end

  it "assigns options named by config[:only] if config[:only] is given" do
    class Cow
      def initialize(options = {}); magic_options(options, :only => :name); end
    end
    @cow = Cow.new(:name => 'Daisy', :color => :brown)
    @cow.instance_variable_get('@name').should == 'Daisy'
  end

  it "ignores options not named by config[:only] if config[:strict] is false" do
    class Cow
      def initialize(options = {}); magic_options(options, :only => :name); end
    end
    @cow = Cow.new(:name => 'Daisy', :color => :brown)
    @cow.should_not be_instance_variable_defined('@color')
  end

  it "raises an error for options not named by config[:only] if config[:strict] is true" do
    class Cow
      def initialize(options = {}); magic_options(options, :only => [:name, :color], :strict => true); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy', :color => :brown, :gender => :female) }.should raise_error(ArgumentError)
  end

  it "assigns options named by instance methods if config[:only] is :respond_to?" do
    class Cow
      attr_accessor :name
      def initialize(options = {}); magic_options(options, :only => :respond_to?); end
    end
    @cow = Cow.new(:name => 'Daisy')
    @cow.instance_variable_get('@name').should == 'Daisy'
  end

  it "ignores options not named by instance methods if config[:only] is :respond_to? and config[:strict] is false" do
    class Cow
      attr_accessor :name
      def initialize(options = {}); magic_options(options, :only => :respond_to?); end
    end
    @cow = Cow.new(:name => 'Daisy', :color => :brown)
    @cow.should_not be_instance_variable_defined('@brown')
  end

  it "raises an error for options not named by instance methods if config[:only] is :respond_to? and config[:strict] is true" do
    class Cow
      attr_accessor :name
      def initialize(options = {}); magic_options(options, :only => :respond_to?, :strict => true); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy', :color => :brown) }.should raise_error(ArgumentError)
  end

  it "accepts an empty options hash without config[:require]" do
    class Cow
      def initialize(options = {}); magic_options(options); end
    end
    lambda { @cow = Cow.new }.should_not raise_error
  end

  it "assigns options named by config[:require] as if named by config[:only] also" do
    class Cow
      def initialize(options = {}); magic_options(options, :require => :name, :only => :color); end
    end
    @cow = Cow.new(:name => 'Daisy', :color => :brown)
    @cow.instance_variable_get('@name').should == 'Daisy'
  end

  it "raises an error for missing options named by config[:require]" do
    class Cow
      def initialize(options = {}); magic_options(options, :require => [:name, :color]); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy') }.should raise_error(ArgumentError)
  end

end

