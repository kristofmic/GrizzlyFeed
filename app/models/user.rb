# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  password_digest        :string(255)
#  cookie_token           :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  theme_id               :integer
#  layout_id              :integer
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  welcome_stage          :integer          default(1)
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_many :user_feeds, dependent: :destroy
  has_many :feeds, through: :user_feeds
  has_many :user_feed_entries, dependent: :destroy
  has_many :feed_entries, through: :user_feed_entries
  belongs_to :theme
  belongs_to :layout

  has_secure_password

  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, on: :create}
  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true
  validates :welcome_stage, inclusion: { within: (0..10) }

  after_validation { self.errors.messages.delete(:password_digest) }

  before_save do 
    generate_token(:cookie_token) 
    self.email.downcase!
    set_theme
    set_layout
  end

  def generate_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
  end

  def clear_password_reset
    self.password_reset_token = nil
    save!(validate: false)
  end

  def update_welcome_stage(new_stage)
    if (0..10).include? new_stage
      self.update_attribute(:welcome_stage, new_stage)
    else
      return false
    end
  end

  private 
    def generate_token(column)  
      begin  
        self[column] = SecureRandom.urlsafe_base64  
      end while User.exists?(column => self[column])  
    end 

    def set_theme
      self.theme = Theme.default if self.theme_id.nil?
    end

    def set_layout
      self.layout = Layout.default if self.layout_id.nil?
    end
end
