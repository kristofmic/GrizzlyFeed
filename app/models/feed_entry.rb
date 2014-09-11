# == Schema Information
#
# Table name: feed_entries
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  url          :string(255)
#  author       :string(255)
#  summary      :text
#  content      :text
#  published_at :datetime
#  guid         :text(255)
#  feed_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class FeedEntry < ActiveRecord::Base
  attr_accessible :author, :content, :guid, :published_at, :summary, :title, :url

  belongs_to :feed
  has_many :user_feed_entries, dependent: :destroy
  has_many :users, through: :user_feed_entries
  has_many :feed_entry_categories, dependent: :destroy
  has_many :categories, through: :feed_entry_categories

  def visited? user
    ufe = self.user_feed_entries.find_by_user_id(user.id)
    !ufe.nil? && (ufe.visited || ufe.viewed || ufe.marked_as_viewed)
  end

  def for_index user=nil
    entry = {
      id: self.id,
      title: self.title, 
      url: self.url,
      published: self.published_at || Time.now,
      author: self.author,
      categories: self.categories.map{ |c| c.category }.first(3),
      feed: {title: self.feed.title, url: self.feed.url}
    } 

    if (self.content.nil?)
      entry[:summary] = self.summary
    elsif (self.summary.nil?)
      entry[:summary] = self.content
    elsif (self.summary.length > self.content.length)
      entry[:summary] = self.summary
    else
      entry[:summary] = self.content
    end

    entry[:visited] = self.visited?(user) unless user.nil? 

    return entry
  end

  def for_home
    entry = self.for_index
    return entry
  end

  def self.add_feed_entries(feed, entries)
    entries.each { |entry| add_feed_entry(feed, entry) }
  end 

  def self.add_feed_entry(feed, entry)
    unless exists? guid: entry.id
      begin 
        fe = feed.feed_entries.create(guid: entry.id,
                published_at: entry.published,
                title: FeedEntry.strip_funky_chars(Sanitize.clean(entry.title, Sanitize::Config::RESTRICTED)), 
                url: Sanitize.clean(entry.url, Sanitize::Config::RESTRICTED),
                author: Sanitize.clean(entry.author, Sanitize::Config::RESTRICTED),
                summary: FeedEntry.strip_funky_chars(Sanitize.clean(entry.summary, transformers_depth: FeedEntry.html_transformer)),
                content: entry.respond_to?(:content) ? FeedEntry.strip_funky_chars(Sanitize.clean(entry.content, transformers_depth: FeedEntry.html_transformer)) : nil
               )
        Category.add_categories(entry.categories, feed_entry: fe) if entry.respond_to? :categories
      rescue Exception => e  
        FeedError.create(url: feed.url, error: e.message[0..254], trace: e.backtrace.join("\n"))
        return nil
      end
    else
      return nil
    end
  end

  def self.html_transformer
    @@html_transformer
  end

  @@html_transformer = lambda do |env| 
    node = env[:node]
    node_name = env[:node_name]
    
    return if env[:is_whitelisted] || !node.element?
    return unless node_name == 'p' || 
                  node_name == 'img' || 
                  node_name == 'a' || 
                  node_name == 'text' || 
                  node.parent.name == 'p'
    
    if node_name == 'img'
      unless node.attributes["width"].nil?
        return if node.attributes["width"].value == "1"
      end

      unless node.attributes["height"].nil?
        return if node.attributes["height"].value == "1"
      end

      return if node.parent.name == 'a'

      unless node.attributes['src'].nil?
        src = node.attributes['src'].value
        if src.index('?')
          node.attributes['src'].value = src.slice(0...src.index('?'))
        end
        if src.index('_thumbnail')
          file_type = src.slice((src.index('_thumbnail') + '_thumbnail'.length)...src.length)
          node.attributes['src'].value = src.slice(0...src.index('_thumbnail')) + file_type
        end
      end
    end

    if node_name == 'a'
      return if node.attributes['rel'] == "nofollow"
      return if node.children.blank? 
      return if node.children.first.name == 'img'
    end
    
    Sanitize.clean_node!(node, 
                        elements: ['a', 'span', 'b', 'em', 'img', 'p', 'blockquote', 'text'],
                        attributes: {'a' => ['href', 'title'], 'img' => ['alt', 'src', 'title']},
                        add_attributes: {'a' => {'rel' => 'nofollow', 'target' => '_blank'}},
                        protocols: {'a' => {'href' => ['http', 'https', 'mailto']}, 'img' => {'src' => ['http', 'https']}},
                        allow_comments: false
    )
    
    whitelist = {node_whitelist: [node]}
    #if node_name == 'p'
    #  whitelist[:node_whitelist].concat(FeedEntry.add_child_nodes(whitelist[:node_whitelist], node.children))
    #end

    return whitelist
  end

  private
    def self.strip_funky_chars a_string
      if a_string.class.eql?(String) 
        a_string = a_string.gsub(/\u00a0/, " ")
        a_string = a_string.gsub(/&amp;/, "&")
      else
        a_string
      end
    end

    def self.add_child_nodes whitelist, child_node_list
      child_node_list.each do |child_node|
        whitelist << child_node
        unless child_node.children.blank?
          whitelist.concat(FeedEntry.add_child_nodes(whitelist, child_node.children))
        end
      end
      return whitelist
    end
end
