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
