require 'spec_helper'

describe BrandsAlias do
  it "should be able to create" do
    BrandsAlias.create().should_not be_nil
  end
end