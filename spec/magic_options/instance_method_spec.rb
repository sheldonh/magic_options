require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'magic_options'

describe "MagicOptions#magic_options(options, config = {})" do

  before(:each) do
    begin; Object.send(:remove_const, :Cow); rescue; end
    class Cow
      include MagicOptions
    end
  end

  it "sets instance variables named after keys in the options hash" do
    class Cow
      def initialize(options = {}); magic_options(options); end
    end
    @cow = Cow.new(:name => 'Daisy', :color => :brown)
    @cow.should be_instance_variable_defined('@name')
    @cow.should be_instance_variable_defined('@color')
  end

  it "sets instance variable values to the values in the options hash" do
    class Cow
      def initialize(options = {}); magic_options(options); end
    end
    @cow = Cow.new(:name => 'Daisy', :color => :brown)
    @cow.instance_variable_get('@name').should == 'Daisy'
    @cow.instance_variable_get('@color').should == :brown
  end

  it "accepts any option names without config[:only]" do
    class Cow
      def initialize(options = {}); magic_options(options); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy', :color => :brown, :gender => :female) }.should_not raise_error
  end

  it "accepts option names included in config[:only]" do
    class Cow
      def initialize(options = {}); magic_options(options, :only => [:name, :color]); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy', :color => :brown) }.should_not raise_error
  end

  it "raises ArgumentError for option names not included in config[:only]" do
    class Cow
      def initialize(options = {}); magic_options(options, :only => [:name, :color]); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy', :color => :brown, :gender => :female) }.should raise_error(ArgumentError)
  end

  it "accepts the absence of options without config[:require]" do
    class Cow
      def initialize(options = {}); magic_options(options); end
    end
    lambda { @cow = Cow.new }.should_not raise_error
  end

  it "raises ArgumentError for absent option names in config[:require]" do
    class Cow
      def initialize(options = {}); magic_options(options, :require => [:name, :color]); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy') }.should raise_error(ArgumentError)
  end

  it "accepts option names in config[:require] even when they are not in config[:only]" do
    class Cow
      def initialize(options = {}); magic_options(options, :require => :name, :only => :color); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy', :color => :brown) }.should_not raise_error
  end

  it "raises ArgumentError for option names absent from both config[:only] and config[:require]" do
    class Cow
      def initialize(options = {}); magic_options(options, :require => :name, :only => :color); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy', :color => :brown, :gender => :female) }.should raise_error(ArgumentError)
  end

  it "accepts option names that match instance method names if config[:only] is :respond_to?" do
    class Cow
      attr_accessor :name, :color
      def initialize(options = {}); magic_options(options, :only => :respond_to?); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy', :color => :brown) }.should_not raise_error
  end

  it "raises ArgumentError for option names that match no instance method names if config[:only] is :respond_to?" do
    class Cow
      attr_accessor :name, :color
      def initialize(options = {}); magic_options(options, :only => :respond_to?); end
    end
    lambda { @cow = Cow.new(:name => 'Daisy', :color => :brown, :gender => :female) }.should raise_error(ArgumentError)
  end

end

