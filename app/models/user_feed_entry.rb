# == Schema Information
#
# Table name: user_feed_entries
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  feed_entry_id    :integer
#  visited          :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  viewed           :boolean          default(FALSE)
#  marked_as_viewed :boolean          default(FALSE)
#

class UserFeedEntry < ActiveRecord::Base
  attr_accessible :user_id, :feed_entry_id, :visited, :viewed, :marked_as_viewed

  belongs_to :user
  belongs_to :feed_entry
end
