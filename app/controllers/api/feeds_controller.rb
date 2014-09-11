class Api::FeedsController < ApiController
  skip_before_filter :user_not_signed_in, :only => [:home]
  
   def create
    @feed = Feed.add_feed(params[:feed_url])
    if @feed
      position = next_col_row
      current_user.user_feeds.create(feed_id: @feed.id, column: position[:column], row: position[:row]) unless current_user.feeds.include? @feed
      render json: @feed.for_browse(current_user)
    else
      render json: {status: 'Error', errors: ['Feed not added. Please verify that the feed URL is valid and does not already exist.']}, status: 400
    end
  end

  def index
    @feeds = current_user.feeds
    @columns = 3
    @response = Hash.new()
    @columns.times do |col|
      col_feeds = @feeds.select { |feed| feed.user_feeds.find_by_user_id(current_user.id).column == (col+1) }
      col_feeds.map! { |feed| feed.for_index(current_user) }
      col_feeds.sort! { |low, high| low[:row] <=> high[:row] }
      @response[(col+1)] = ( col_feeds )
    end
    @response[:updated] = last_updated(@feeds)
    render json: @response
  end

  def refresh
    @feed_entries = recent_feeds_entries current_user.feeds 
    render json: {updated: last_updated(current_user_from_db.feeds), feeds: @feed_entries} 
  end

  def browse
    offset = params[:offset] || 0
    limit = params[:limit] || 28
    @feeds = Feed.find(:all, order: 'title asc', limit: limit, offset: offset)
    @response = []
    @feeds.each { |feed| @response << feed.for_browse(current_user) }
    render json: @response
  end

  def search
    if params[:search][0] == '#'
      params[:search][0] = ''
      @search = Feed.search do
       fulltext params[:search] do
        fields(:categories)
       end
     end
    else
      @search = Feed.search { fulltext params[:search] }
    end
    
    
    @feeds  = @search.results
    @response = []
    @feeds.each { |feed| @response << feed.for_browse(current_user) }
    render json: @response
  end

  def home
    offset = params[:offset] || 0
    limit = params[:limit] || 28
    @columns = 3
    @response = {}
    
    @feed_entries = FeedEntry.find(:all, order: 'published_at desc', limit: limit, offset: offset)
    @feed_entries.map! { |entry| entry.for_home }
    
    @columns.times do |col|
      c = col
      indeces = [c]
      c += 3
      while c < limit.to_i do
        indeces << c
        c += 3
      end
      col_entries = @feed_entries.values_at(*indeces)
      @response[(col+1)] = ( col_entries )
    end
    render json: @response
  end

end