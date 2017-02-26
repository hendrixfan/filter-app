class Resources::NewsItems < Grape::API
  include BaseApi
  namespace :news_items do
    params do
      optional :to, Date
      optional :page, Integer, default: 1
      optional :limit, Integer, default: 30
      optional :source_id, Integer
      optional :preferred, String
      optional :blacklisted, String
      optional :categories, String
    end
    get '/' do
      filter = NewsFilter.new(preferred: params[:preferred], blacklisted: params[:blacklisted], per_page: params[:limit], page: params[:page], categories: params[:categories])
      @news_items = filter.news_items
      if params[:source_id]
        @news_items = @news_items.where(source_id: params[:source_id])
      end
      render @news_items, meta: { total_count: @news_items.total_entries, pages: @news_items.total_pages, current_page: @news_items.current_page }
    end
  end

  namespace :categories do
    get '/' do
      Category.sorted
    end
  end

  namespace :sources do
    params do
      optional :category_id, Integer
    end
    get '/' do
      base = Source.visible.order('name')
      if params[:category_id]
        base = base.where(default_category_id: params[:category_id])
      end
      base
    end
  end

end

