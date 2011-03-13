require 'spec_helper'

describe PreviewEmail do
  it "should be able to create" do
    PreviewEmail.create().should_not be_nil
  end
end
