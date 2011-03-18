class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => :home

  def home
    @title = 'Cuphon Controlpanel'
  end
end
