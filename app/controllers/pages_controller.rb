class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => :home

  def home
  end
  def brands_view
    @title = 'Brands'
    @brands = Brand.find(:all, :order => "id desc").paginate(:page => params[:page])
  end
end
