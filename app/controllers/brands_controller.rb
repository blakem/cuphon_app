class BrandsController < ApplicationController
  before_filter :authenticate_user!

  def list
    sort_args = get_sort_args(params[:sort])
    @title = 'Brands'
    @brands = Brand.find(:all, sort_args).paginate(:page => params[:page], :per_page => 100)
    @sort_args={:brand => {:sort => params[:sort] == 'brand_asc' ? 'brand_desc' : 'brand_asc'},
                :created_at => {:sort => params[:sort] == 'created_at_asc' ? 'created_at_desc' : 'created_at_asc'},
                :subscriber => {:sort => params[:sort] == 'subscriber_desc' ? 'subscriber_asc' : 'subscriber_desc'}}
  end

  private
    def get_sort_args(key)
      {'brand_desc' =>      {:order =>'title desc'},
       'brand_asc' =>       {:order => 'title asc'},
       'created_at_desc' => {:order => 'created_at desc'},
       'created_at_asc' =>  {:order => 'created_at asc'},
       'subscriber_desc' => {:order => '(SELECT COUNT(*) FROM subscriptions WHERE (brands.id=subscriptions.brand_id)) desc'},
       'subscriber_asc' => {:order => '(SELECT COUNT(*) FROM subscriptions WHERE (brands.id=subscriptions.brand_id)) asc'}
      }[key] || {:order => 'id desc'}
    end
end
