module UserFeedsHelper

	def next_col_row
		@max_row ||= current_user_feeds.max_by{ |uf| uf.row }
		
		if @max_row
			@max_row.row.times do |mrow|  
				3.times do |mcol|
					unless current_user_feeds.detect{ |uf| uf.row == (mrow+1) && uf.column == (mcol+1) }
						return { column: (mcol+1), row: (mrow+1) } 
					end
				end
			end

			return { column: 1, row: (@max_row.row+1) }
		else
			return { column: 1, row: 1 }
		end
	end

	def update_cols_rows deleted_user_feed
		col_user_feeds = current_user_feeds.select { |uf| uf.column == deleted_user_feed.column && uf.row > deleted_user_feed.row }
		col_user_feeds.each { |uf| uf.update_attribute(:row, (uf.row - 1)) }
	end

	def current_user_feeds
		@user_feeds ||= current_user.user_feeds.select { |uf| !uf.feed_id.blank? }
	end

	def current_user_feed feed_id
		current_user_feeds.detect{ |uf| uf.feed_id == feed_id.to_i }
	end

end