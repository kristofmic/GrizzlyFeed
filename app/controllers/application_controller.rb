class ApplicationController < ActionController::Base
  include SessionsHelper
  include FeedsHelper
 	include UserFeedsHelper
 	include ThemesHelper
 	include LayoutsHelper
  include RoutesHelper

  protect_from_forgery

  after_filter :set_csrf_cookie_for_ng
end
