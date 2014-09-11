class ApiController < ApplicationController
  before_filter :user_not_signed_in
  respond_to :json
end