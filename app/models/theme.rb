# == Schema Information
#
# Table name: themes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stylesheet :string(255)
#

class Theme < ActiveRecord::Base
  attr_accessible :name, :stylesheet

  has_many :users

  def self.default
  	Theme.find_by_name('Default')
  end
end
