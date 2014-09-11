module FeedsHelper

	def refresh_feeds feeds
		feeds.each { |f| Feed.update_feed(f.feed_url) }
	end

	def recent_feeds_entries feeds
		refresh_feeds feeds
		feed_hash = {}
		feeds.each { |f| feed_hash[f.id] = recent_entries(f) }
		feed_hash
	end

	def recent_entries feed
		count = entries_count(feed)
		count ? feed.recent_entries(current_user, count) : feed.recent_entries(current_user)
	end

	def entries_count feed
		user_feed = feed.user_feeds.find_by_user_id(current_user.id)
		if user_feed
			user_feed.entries
		end
	end

	def last_updated feeds
		feeds.min_by{ |f| f.last_modified }.last_modified.to_formatted_s(:rfc822) unless feeds.blank?
	end 

end