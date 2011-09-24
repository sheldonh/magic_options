require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "MagicOptions::ClassMethods#magic_initialize" do

  context "Given class Cow mixes in MagicOptions" do

    require 'magic_options'
    class Cow
      include MagicOptions
    end

    context "When it calls magic_initialize" do

      class Cow
        magic_initialize
      end
      
      context "Then Cow.new(:name => 'Daisy', :color => :brown)" do

        before(:each) do
          @cow = Cow.new(:name => 'Daisy', :color => :brown)
        end

        it "sets @name to 'Daisy'" do
          @cow.instance_variable_get('@name').should == 'Daisy'
        end

        it "sets @color to :brown" do
          @cow.instance_variable_get('@color').should == :brown
        end

      end

    end

    context "When it calls magic_initialize(:only => [:name, :color])" do

      class Cow
        magic_initialize :only => [:name, :color]
      end

      context "Then Cow.new(:name => 'Daisy', :color => :brown)" do

        before(:each) do
          @cow = Cow.new(:name => 'Daisy', :color => :brown)
        end

        it "sets @name to 'Daisy'" do
          @cow.instance_variable_get('@name').should == 'Daisy'
        end

        it "sets @color to :brown" do
          @cow.instance_variable_get('@color').should == :brown
        end

      end

      context "Then Cow.new(:name => 'Daisy', :gender => :female)" do

        it "raises an ArgumentError" do
          lambda {
            Cow.new(:name => 'Daisy', :gender => :female)
          }.should raise_error(ArgumentError)
        end

        it "reports the offending class and the unknown option" do
          lambda {
            Cow.new(:name => 'Daisy', :gender => :female)
          }.should raise_error("Unknown option gender in new Cow")
        end

      end

    end

    context "When it calls magic_initialize(:require => :name)" do

      class Cow
        magic_initialize :require => :name
      end

      context "Then Cow.new(:name => 'Daisy', :color => :brown)" do

        before(:each) do
          @cow = Cow.new(:name => 'Daisy', :color => :brown)
        end

        it "sets @name to 'Daisy'" do
          @cow.instance_variable_get('@name').should == 'Daisy'
        end

        it "sets @color to :brown" do
          @cow.instance_variable_get('@color').should == :brown
        end

      end

      context "Then Cow.new(:color => :brown)" do

        it "raises an ArgumentError" do
          lambda { @cow = Cow.new(:color => :brown) }.should raise_error(ArgumentError)
        end

        it "reports the offending class and the missing option" do
          lambda { @cow = Cow.new(:color => 'Daisy') }.should raise_error("Missing option name in new Cow")
        end
      end

    end

    context "When it calls magic_initialize(:only => :color, :require => :name)" do

      class Cow
        magic_initialize :only => :color, :require => :name
      end

      context "Then Cow.new(:name => 'Daisy', :color => :brown)" do

        before(:each) do
          @cow = Cow.new(:name => 'Daisy', :color => :brown)
        end

        it "sets @name to 'Daisy'" do
          @cow.instance_variable_get('@name').should == 'Daisy'
        end

        it "sets @color to :brown" do
          @cow.instance_variable_get('@color').should == :brown
        end

      end

      context "Then Cow.new(:color => :brown)" do

        it "raises an ArgumentError" do
          lambda { @cow = Cow.new(:color => :brown) }.should raise_error(ArgumentError)
        end

        it "reports the offending class and the missing option" do
          lambda { @cow = Cow.new(:color => 'Daisy') }.should raise_error("Missing option name in new Cow")
        end

      end

    end

  end

end

