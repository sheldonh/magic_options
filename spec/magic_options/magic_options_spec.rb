require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "MagicOptions" do

  describe "#initialize" do

    context "with default magic_options" do

      before(:each) do
        require 'magic_options'
        class Klazz
          include MagicOptions
          attr_accessor :accessible
        end
      end

      it "sets instance variables for all options" do
        object = Klazz.new(:color => "green")
        object.should be_instance_variable_defined(:@color)
        object.instance_variable_get(:@color).should == "green"
      end

    end

    context "with magic_options :accessors" do

      before(:each) do
        require 'magic_options'
        class Klazz
          include MagicOptions
          magic_options :accessors
          attr_accessor :accessible
        end
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
        require 'magic_options'
        class Klazz
          include MagicOptions
          magic_options :color, :shape
          attr_accessor :accessible
        end
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

    context "given a disallowed option" do

      before(:each) do
        require 'magic_options'
        class Klazz
          include MagicOptions
          magic_options :allowed
          attr_accessor :accessible
        end
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

end
