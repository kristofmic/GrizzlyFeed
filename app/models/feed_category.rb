# == Schema Information
#
# Table name: feed_categories
#
#  id          :integer          not null, primary key
#  category_id :integer
#  feed_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FeedCategory < ActiveRecord::Base
  attr_accessible :category_id, :feed_id

  belongs_to :category
  belongs_to :feed
end
