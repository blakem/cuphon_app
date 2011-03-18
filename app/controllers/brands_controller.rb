class BrandsController < ApplicationController
  before_filter :authenticate_user!

  def list
    sort_string = get_sort_string(params[:sort])
    @title = 'Brands'
    @brands = Brand.find(:all, :order => sort_string).paginate(:page => params[:page], :per_page => 100)
    @sort_args={:brand => {:sort => params[:sort] == 'brand_desc' ? 'brand_inc' : 'brand_desc'}}
  end

  private
    def get_sort_string(key)
      {'brand_desc' => 'title desc',
       'brand' => 'title'      
      }[key] || 'id desc'
    end
end
