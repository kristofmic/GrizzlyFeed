class Api::UserFeedsController < ApiController

  def destroy
    @user_feed = current_user_feed(params[:id])
    if @user_feed
      @user_feed.destroy
      update_cols_rows @user_feed
      @response = {status: 'Success', feed: {id: @user_feed.feed_id, subscribers: Feed.find(@user_feed.feed_id).users.count}}
      render json: @response
    else
      @response = {status: 'Error', errors: ['Feed not found for the user']}
      render json: @response, status: 400
    end
  end

  def update
    @user_feed = current_user_feed(params[:id])
    if @user_feed && params[:user_feed]
      @user_feed.update_attributes(params[:user_feed])
      @feed = Feed.find(@user_feed.feed_id)
      @response = {status: 'Success', feed: @feed.for_index(current_user)}
      render json: @response
    else
      @response = {status: 'Error', errors: ['Feed not found for the user']}
      render json: @response, status: 400
    end
  end

  def update_all
    @positions = params[:positions]
    if @positions && current_user_feeds
      @positions.each do |feed| 
        @uf = current_user_feeds.detect{ |uf| uf.feed_id == feed[:id] }
        @uf.update_attributes(column: feed[:column], row: feed[:row]) if @uf
      end
      @response = {status: 'Success'}
      render json: @response
    else
      @response = {status: 'Error', errors: ['Bad request']}
      render json: @response, status: 400
    end
  end

  def create
    @feed = Feed.find(params[:feed_id])
    if @feed
      position = next_col_row
      current_user.user_feeds.create(feed_id: @feed.id, column: position[:column], row: position[:row])
      system "rake feeds:update FEED_URL=#{@feed.feed_url} &"
      @response = {status: 'Success', feed: {id: @feed.id, subscribers: @feed.users.count}}
      render json: @response
    else
      @response = {status: 'Error', errors: ['Feed not found']}
      render json: @response, status: 400 
    end
  end

end