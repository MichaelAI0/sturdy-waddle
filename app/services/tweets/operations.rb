module Tweets
  module Operations
    def self.new_tweet(params, current_user)
      tweet = current_user.tweets.new(content: params[:content])

      return ServiceContract.success(tweet) if tweet.save
      
      ServiceContract.error(tweet.errors.full_messages)
    end
  end
end