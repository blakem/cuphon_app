class BrandsController < ApplicationController
  before_filter :authenticate_user!

  def list
    sort_string = get_sort_string(params[:sort])
    @title = 'Brands'
    @brands = Brand.find(:all, :order => sort_string).paginate(:page => params[:page], :per_page => 100)
    @sort_args={:brand => {:sort => params[:sort] == 'brand_asc' ? 'brand_desc' : 'brand_asc'},
                :created_at => {:sort => params[:sort] == 'created_at_asc' ? 'created_at_desc' : 'created_at_asc'}}
  end

  private
    def get_sort_string(key)
      {'brand_desc' => 'title desc',
       'brand_asc' => 'title asc',
       'created_at_desc' => 'created_at desc',
       'created_at_asc' => 'created_at asc'
      }[key] || 'id desc'
    end
end
