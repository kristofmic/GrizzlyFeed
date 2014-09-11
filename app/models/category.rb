# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  attr_accessible :category

  validates :category, presence: true, uniqueness: {case_sensitive: false}

  before_save { self.category.downcase! }

  has_many :feed_entry_categories, dependent: :destroy
  has_many :feed_entries, through: :feed_entry_categories
  has_many :feed_categories, dependent: :destroy
  has_many :feeds, through: :feed_categories

  def self.add_categories(categories, options = {})
    unless categories.blank?
      categories.each do |c|
        unless exists? category: c
          cat = Category.create(category: c)
        else
          cat = Category.find_by_category(c.downcase)
        end

        unless options.blank?
          options[:feed_entry].feed_entry_categories.create(category_id: cat.id) if(options[:feed_entry] && !options[:feed_entry].categories.exists?(category: cat.category))
          options[:feed].feed_categories.create(category_id: cat.id) if(options[:feed] && !options[:feed].categories.exists?(category: cat.category))
        end
      end
    end
  end

  def self.get_categories(options = {})
    cat = []
    unless options.blank?
      cat.concat(options[:feed_entry].categories.map { |c| c.category }) if options[:feed_entry]
      cat.concat(options[:feed].categories.map { |c| c.category }) if options[:feed]
    else
      cat = Category.all.map { |c| c.category }
    end
    cat 
  end
end
