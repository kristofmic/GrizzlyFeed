# == Schema Information
#
# Table name: layouts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  icon       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Layout < ActiveRecord::Base
  attr_accessible :name, :icon

  has_many :users

  def self.default
  	Layout.find_by_name('Grid')
  end
end
