class PagesController < ApplicationController
  def voice
  end

  def sms
    @number = request.params[:From]
    @name = 'Monkey Man'
  end
end
