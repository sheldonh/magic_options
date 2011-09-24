require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "MagicOptions#magic_options" do

  context "Given class Cow mixes in MagicOptions" do

    before(:each) do
      require 'magic_options'
      class Cow
        include MagicOptions
      end
    end

    context "When Cow#initialize(options) calls magic_options(options)" do

      before(:each) do
        class Cow
          def initialize(options = {})
            magic_options options
          end
        end
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

    context "When Cow#initialize(options) calls magic_options(options, :only => [:name, :color])" do

      before(:each) do
        class Cow
          def initialize(options)
            magic_options(options, :only => [:name, :color])
          end
        end
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

    context "When Cow#initialize(options) calls magic_options(options, :require => :name)" do

      before(:each) do
        class Cow
          def initialize(options)
            magic_options(options, :require => :name)
          end
        end
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

    context "When Cow#initialize(options) calls magic_options(options, :only => :color, :require => :name)" do

      before(:each) do
        class Cow
          def initialize(options)
            magic_options(options, :only => :color, :require => :name)
          end
        end
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

