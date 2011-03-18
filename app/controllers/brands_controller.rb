class BrandsController < ApplicationController
  before_filter :authenticate_user!

  def list
    @title = 'Brands'
    @brands = Brand.find(:all, :order => "id desc").paginate(:page => params[:page], :per_page => 100)
  end
end
