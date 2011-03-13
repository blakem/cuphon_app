require 'spec_helper'

describe LogMerchantLogin do
  it "should be able to create" do
    LogMerchantLogin.create().should_not be_nil
  end
end
