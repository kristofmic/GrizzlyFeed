# == Schema Information
#
# Table name: feed_errors
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  error      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trace      :text
#

class FeedError < ActiveRecord::Base
  attr_accessible :error, :url, :trace
end
