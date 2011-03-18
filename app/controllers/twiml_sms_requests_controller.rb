class TwimlSmsRequestsController < ApplicationController
  before_filter :authenticate_user!

  def list
    @title = 'SmsRequests'
    @twiml_sms_requests = TwimlSmsRequest.find(:all, :order => "id desc").paginate(:page => params[:page], :per_page => 100)
  end

end
