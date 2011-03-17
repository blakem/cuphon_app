require 'spec_helper'

describe PasswordReset do
  it "should be able to create" do
    PasswordReset.create().should_not be_nil
  end
  
  describe "default values" do
    it "should set used to false" do
      passwordreset = PasswordReset.create
      passwordreset.used.should  == 'false' 

      passwordreset.reload
      passwordreset.used.should  == 'false'
    end
  end
end

def class_from_filename(file)
  file.gsub(/.*\//,'').gsub(/\.rb/,'').classify
end

def enums_from_filename(file)
  enums = []
  File.open(file, "r").each do |line|
    next unless line =~ /string\(0\)/
    line =~ /#\s*(\w+)\s/
    enums << $1
  end
  enums
end

Dir["app/models/*"].each do |file|
  clazz = class_from_filename(file)
  enums_from_filename(file).each do |field|
    describe "#{clazz}" do
      it "should have an accessor for enum field: #{field}" do
        test_method(clazz, field)
      end
    end
  end
end


def test_method(clazz, method)
  return if method == 'type'
  o = Kernel.const_get(clazz).new
  o.send(method + "=", 'true')
  o.send(method + "?").should be_true
  o.send(method + "=", 'false')
  o.send(method + "?").should be_false
end
