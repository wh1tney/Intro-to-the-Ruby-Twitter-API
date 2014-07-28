require 'twitter'
require 'debugger'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "jx5WiY36buuyDzwawKvEnbLJs"
  config.consumer_secret     = "K5lbvgDrQuH7y9fq2r1PRhjSAVsHv8FVGOhnPtgZWclUfMgCaJ"
  config.access_token        = "42455376-iKLnHVnY1qNCd6J1OcjNg9Dnt8mMJXMpwtVxg7YO7"
  config.access_token_secret = "eN28gZRU8glQ2H4Yn1dnlBC61WYg9qJxhdGM86NoYj3eC"
end



puts client.status(167309659198328832).text

# class Twitter::REST::Client
# 	def get_all_tweets_blockless(user, collection=[], max_id=nil)
# 		options = {count: 50, include_rts: true}
# 		options[:max_id] = max_id unless max_id.nil?
# 		response = user_timeline(user, options)
# 		collection += response
# 		response.empty? ? collection.flatten : get_all_tweets_blockless(user, collection, response.last.id - 1)
# 	end
# end

# def client.get_all_tweets_blockless(user, collection=[], max_id=nil)
# 	options = {count: 50, include_rts: true}
# 	options[:max_id] = max_id unless max_id.nil?
# 	response = user_timeline(user, options)
# 	collection += response
# 	response.empty? ? collection.flatten : self.get_all_tweets_blockless(user, collection, response.last.id - 1)
# end

def client.collect_with_max_id(collection=[], max_id=nil, &block)
	response = block.call(max_id)
	collection += response
	response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

# def client.get_all_tweets(user, &block)
# 	debugger
# 	block.call(self) do |max_id|
# 		options = {count: 50, include_rts: true}
# 		options[:max_id] = max_id unless max_id.nil?
# 		user_timeline(user, options)
# 	end
# end

def client.get_all_tweets(user, &block)
	# debugger
	block.call(self) do |since_id|
		options = {count: 50, include_rts: true}
		options[:since_id] = since_id unless since_id.nil?
		user_timeline(user, options)
	end
end



def set_options_call_user_timeline(limiting_id)
	options = {count: 50, include_rts: true}
	options[:max_id] = max_id unless max_id.nil?
	user_timeline(user, options)

end

# def client.get_all_tweets_since_oldest(user)
# 	collect_with_since_id do |since_id|
# 		options = {count: 50, include_rts: true}
# 		options[:since_id] = since_id unless since_id.nil?
# 		user_timeline(user, options)
# 	end
# end

def client.collect_with_since_id(collection=[], since_id=nil, &block)
	response = block.call(since_id)
	collection += response
	response.empty? ? collection.flatten : collect_with_since_id(collection, response.first.id + 1, &block)
end

# def collect_with_max_id_limited(num_of_tweets, collection=[], max_id=nil, &block)
# 	response = block.call(max_id)
# 	collection += response
# 	collection.count >= num_of_tweets ? collection.flatten : collect_with_max_id_limited(num_of_tweets, collection, response.last.id - 1, &block)
# end

# def client.get_limited_most_recent_tweets(user, num_of_tweets)
# 	collect_with_max_id_limited(num_of_tweets) do |max_id|
# 		options = {include_rts: true}
# 		options[:max_id] = max_id unless max_id.nil?
# 		user_timeline(user, options)
# 	end
# end


recent_tweets = client.get_all_tweets("opleban", &:collect_with_since_id)

recent_tweets.each do |tweet|
	puts tweet.full_text
end

p recent_tweets.count

# p client.user_timeline("wjoba", {include_rts:true}).count

# p recent_tweets.count
