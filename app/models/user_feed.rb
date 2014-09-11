# == Schema Information
#
# Table name: user_feeds
#
#  id         :integer          not null, primary key
#  feed_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entries    :integer          default(5)
#  column     :integer          default(0)
#  row        :integer          default(0)
#

class UserFeed < ActiveRecord::Base
  attr_accessible :feed_id, :user_id, :entries, :column, :row

  belongs_to :feed
  belongs_to :user

  validates :entries, inclusion: { in: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 30, 50, 100], message: "%{value} is not a valid number of entries"}
end
