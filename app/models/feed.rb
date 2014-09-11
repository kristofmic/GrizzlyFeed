# == Schema Information
#
# Table name: feeds
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  url           :string(255)
#  feed_url      :string(255)
#  etag          :string(255)
#  last_modified :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Feed < ActiveRecord::Base
  attr_accessible :etag, :feed_url, :last_modified, :title, :url

  has_many :feed_entries, dependent: :destroy
  has_many :user_feeds, dependent: :destroy
  has_many :users, through: :user_feeds
  has_many :feed_categories, dependent: :destroy
  has_many :categories, through: :feed_categories

  searchable do
    text :title
    text :url
    text :feed_url
    text :categories do
      categories.map(&:category)
    end
  end
  #handle_asynchronously :solr_index
  #handle_asynchronously :remove_from_index

  def recent_entries(user, count = 5)
    self.feed_entries.order('published_at desc').first(count).map { |entry|
      entry.for_index(user)
    }
  end

  def for_index user
    @user_feed = self.user_feeds.find_by_user_id(user.id)
    { id: self.id, 
      title: self.title, 
      url: self.url, 
      feed_url: self.feed_url, 
      last_modified: self.last_modified.to_formatted_s(:long_ordinal), 
      subscribers: self.users.count,
      row: @user_feed.row,
      column: @user_feed.column, 
      entries: recent_entries(user, @user_feed.entries)
    }
  end

  def for_browse user
    @user_feed = self.user_feeds.find_by_user_id(user.id)
    { 
      id: self.id, 
      title: self.title, 
      url: self.url, 
      feed_url: self.feed_url, 
      last_modified: self.last_modified.to_formatted_s(:rfc822), 
      subscribers: self.users.count,
      categories: Category.get_categories(feed: self).first(3), 
      added: !@user_feed.nil?
    }
  end 

  def add_categories cats = [] 
    cats.each { |cat| Category.add_categories(cats, feed: self) }
  end

  def self.add_feed(feed_url)
    unless exists? feed_url: feed_url
      begin 
        new_feed = Feedzirra::Feed.fetch_and_parse(feed_url)
        feed = create!( title: new_feed.title,
                        url: new_feed.url,
                        feed_url: new_feed.feed_url,
                        etag: new_feed.etag,
                        last_modified: new_feed.last_modified
                      )
        FeedEntry.add_feed_entries feed, new_feed.entries
        return feed
      rescue Exception => e  
        FeedError.create(url: feed_url, error: e.message[0..254], trace: e.backtrace.join("\n"))
        return nil
      end
    else
      return nil
    end
  end

  def self.update_feed(feed_url)
    feed = find_by_feed_url feed_url
    if feed
      begin
        feed_to_update = Feedzirra::Parser::Atom.new
        feed_to_update.feed_url = feed.feed_url
        feed_to_update.etag = feed.etag

        last_feed_entry = feed.feed_entries.blank? ? nil : feed.feed_entries.max_by{ |x| x.published_at }
        last_entry = Feedzirra::Parser::AtomEntry.new

        unless last_feed_entry.nil?
          feed_to_update.last_modified = last_feed_entry.published_at
          last_entry.url = last_feed_entry.url
        else
          feed_to_update.last_modified = feed.created_at
          last_entry.url = nil
        end
        feed_to_update.entries = [last_entry]

        updated_feed = Feedzirra::Feed.update(feed_to_update)
        if updated_feed 
          if updated_feed.etag != feed.etag || updated_feed.last_modified != feed.last_modified
            feed = update(feed.id, 
                        feed_url: updated_feed.feed_url,
                        etag: updated_feed.etag,
                        last_modified: updated_feed.last_modified
                        )
          end
          if !updated_feed.new_entries.blank? && updated_feed.new_entries.max_by{ |x| x.published }.published > feed.feed_entries.max_by{ |x| x.published_at }.published_at
            FeedEntry.add_feed_entries(feed, updated_feed.new_entries) 
          end
        end
        feed.update_attribute(:last_modified, Time.now)
      rescue Exception => e 
        FeedError.create(url: feed_url, error: e.message[0..254], trace: e.backtrace.join("\n"))
        return nil
      end
    end
    feed
  end
end
