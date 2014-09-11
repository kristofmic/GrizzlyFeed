class FeedsController < ApplicationController
  before_filter :user_not_signed_in

  def index
    render partial: 'feeds/index'
  end

  def new
    render partial: 'feeds/new'
  end

end