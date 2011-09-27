require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'magic_options'

describe "MagicOptions::ClassMethods#magic_initialize(config = {})" do

  before(:each) do
    begin; Object.send(:remove_const, :Cow); rescue; end
    class Cow
      include MagicOptions
    end
  end

  it "creates an initialize(options = {}) instance method" do
    class Cow
      @@methods_added = []
      def self.methods_added; @@methods_added; end
      def self.method_added(method_name); @@methods_added << method_name; end
      magic_initialize
    end
    Cow.methods_added.should include(:initialize)
  end

  it "sets up initialize to pass through its options as magic_options' first argument" do
    class Cow
      magic_initialize
      attr_accessor :initialized_with_options
      alias_method :real_initialize, :initialize
      def initialize(options = {})
        self.initialized_with_options = options
        real_initialize(options)
      end
    end
    cow = Cow.new(:name => 'Daisy')
    cow.initialized_with_options.should == {:name => 'Daisy'}
  end

  it "sets up initialize to pass the given config as magic_options's second argument" do
    class Cow
      magic_initialize :only => :name
      attr_accessor :magicked_with_config
      alias_method :real_magic_options, :magic_options
      def magic_options(options, config = {})
        self.magicked_with_config = config
        real_magic_options(options, config)
      end
    end
    cow = Cow.new(:name => 'Daisy')
    cow.magicked_with_config.should == {:only => :name}
  end

end
