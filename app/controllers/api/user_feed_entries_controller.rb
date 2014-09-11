class Api::UserFeedEntriesController < ApiController

  def create
    @feed_entry = FeedEntry.find(params[:feed_entry_id])
    if @feed_entry
      current_user.user_feed_entries.create(params[:user_feed_entry])
      @response = {status: 'Success'}
      render json: @response
    else
      @response = {status: 'Error', errors: ['Feed entry not found']}
      render json: @response, status: 400 
    end
  end

  def update
    @user_feed_entry = current_user.user_feed_entries.find_by_feed_entry_id(params[:id])
    if @user_feed_entry
      @user_feed_entry.update_attributes(params[:user_feed_entry])
      @response = {status: 'Success'}
      render json: @response
    else
      @response = {status: 'Error', errors: ['User feed entry not found']}
      render json: @response, status: 400 
    end
  end
end