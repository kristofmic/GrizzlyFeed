desc "Heroku scheduler task to update user feeds"
task :update_user_feeds => :environment do
  puts "Updating user feeds..."
  start_time = Time.now
  UserFeed.all.uniq{|uf| uf.feed_id}.each do |uf2|
    f = Feed.find(uf2.feed_id)
    puts "Running update for feed: #{f.id} / #{f.title}"
    Feed.update_feed f.feed_url if f
  end
  end_time = Time.now
  puts "Done. Total time to update was #{end_time - start_time}"
end


desc "Heroku scheduler task to update all feeds"
task :update_all_feeds => :environment do
  puts "Updating all feeds..."
  start_time = Time.now
  Feed.all.each do |f| 
    puts "Running update for feed: #{f.id} / #{f.title}"
    Feed.update_feed f.feed_url 
  end
  end_time = Time.now
  puts "Done. Total time to update was #{end_time - start_time}"
end
