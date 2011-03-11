require 'spec_helper'

describe TwimlSmsRequest do
  it "should ignore extra fields with create_from_params" do
    twiml = TwimlSmsRequest.create_from_params(:From => '12345', :Body => 'Hi There', 'garbage' => 'Foo', :Junk => 'other')
    twiml.From.should == '12345'
    twiml.Body.should == 'Hi There'
    twiml.reload
    twiml.From.should == '12345'
  end
end
