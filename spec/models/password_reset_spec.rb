require 'spec_helper'

describe PasswordReset do
  it "should be able to create" do
    PasswordReset.create().should_not be_nil
  end
end
