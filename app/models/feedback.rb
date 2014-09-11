# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  title      :string(255)
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Feedback < ActiveRecord::Base
  attr_accessible :email, :message, :name, :title

  validates :email, presence: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, on: :create}
  validates :name, presence: true
  validates :title, presence: true
  validates :message, presence: true

end
