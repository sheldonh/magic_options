require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'magic_options'

describe "MagicOptions::ClassMethods#magic_initialize(config = {})" do

  before(:each) do
    begin; Object.send(:remove_const, :Cow); rescue; end
    class Cow
      include MagicOptions
    end
  end

  it "sets up initialize to pass through its options as magic_options' first argument" do
    class Cow
      magic_initialize
    end

    Cow.any_instance.should_receive(:magic_options).with({:name => "Daisy"}, {})

    cow = Cow.new(:name => 'Daisy')
  end

  it "sets up initialize to pass the given config as magic_options's second argument" do
    class Cow
      magic_initialize :only => :name
    end

    Cow.any_instance.should_receive(:magic_options).with({:name => "Daisy"}, { :only => :name })

    cow = Cow.new(:name => 'Daisy')
  end

end
