require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "MagicOptions" do

  require 'magic_options'
  class Klazz
    include MagicOptions
    attr_accessor :accessible
  end

  context "without specifying magic_options" do

    it "sets instance variables for all options" do
      object = Klazz.new(:color => "green")
      object.instance_variables.should include("@color")
      object.instance_variable_get(:@color).should == "green"
    end

  end

  context "with magic_options :accessors" do

    before(:each) do
      Klazz.send :magic_options, :accessors
    end

    it "allows options named after accessors" do
      lambda {
        object = Klazz.new(:accessible => "is an accessor")
      }.should_not raise_error
    end

    it "disallows any other option" do
      lambda {
        object = Klazz.new(:color => "is not an accessor")
      }.should raise_error(ArgumentError)
    end

  end

  context "with magic_options :color, :shape" do

    before(:each) do
      Klazz.send :magic_options, :color, :shape
    end

    it "allows an option called :color" do
      lambda {
        object = Klazz.new(:color => "green")
      }.should_not raise_error
    end

    it "allows options an option called :shape" do
      lambda {
        object = Klazz.new(:shape => "round")
      }.should_not raise_error
    end

    it "disallows any other option" do
      lambda {
        object = Klazz.new(:size => "is not a magic option")
      }.should raise_error
    end

  end

  context "with a disallowed option" do

    before(:each) do
      Klazz.send :magic_options, :allowed
    end

    it "raises an ArgumentError" do
      lambda {
        object = Klazz.new(:size => "is not a magic option")
      }.should raise_error(ArgumentError)
    end

    it "says which class disallowed which option" do
      lambda {
        object = Klazz.new(:size => "is not a magic option")
      }.should raise_error("Unknown option size in new Klazz")
    end

  end

end
