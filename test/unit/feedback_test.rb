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

require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
