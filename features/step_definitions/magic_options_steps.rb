Given /^a class$/ do
  begin; Object.send(:remove_const, :Cow); rescue; end
  class Cow
  end
end

Given /^it mixes in MagicOptions$/ do
  class Cow
    include MagicOptions
  end
end

Given /^its initialize method calls magic_options\(options(, *.+)?\)$/ do |comma_config|
  eval %{
    class Cow
      def initialize(options)
        magic_options(options#{comma_config})
      end
    end
  }
end

When /^it receives new\((.+)\)$/ do |options|
  begin
    eval %{ @cow = Cow.new(#{options}) }
  rescue Exception => e
    @exception = e
  end
end

Then /^the instance has (@\S+) set to (.+)$/ do |instance_variable, value|
  eval %{ @cow.instance_variable_get("#{instance_variable}").should == #{value} }
end

Then /^an ArgumentError is raised$/ do
  @exception.should be_a(ArgumentError)
end

Then /^the error message is "(.+)"$/ do |error_message|
  @exception.message.should include error_message
end

