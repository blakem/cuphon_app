class TwimlSmsRequest < ActiveRecord::Base
  
  def self.new_from_params(params)
    self.new(
     :AccountSid   => params[:AccountSid],
     :Body         => params[:Body],
     :From         => params[:From],
     :FromCity     => params[:FromCity],
     :FromCountry  => params[:FromCountry],
     :FromState    => params[:FromState],
     :FromZip      => params[:FromZip],
     :SmsSid       => params[:SmsSid],
     :To           => params[:To],
     :ToCity       => params[:ToCity],
     :ToCountry    => params[:ToCountry],
     :ToState      => params[:ToState],
     :ToZip        => params[:ToZip],
    )
  end
end
