# == Schema Information
#
# Table name: feed_entry_categories
#
#  id            :integer          not null, primary key
#  category_id   :integer
#  feed_entry_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class FeedEntryCategory < ActiveRecord::Base
  attr_accessible :category_id, :feed_entry_id

  belongs_to :category
  belongs_to :feed_entry
end
