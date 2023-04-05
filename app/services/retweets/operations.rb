module Retweets
  module Operations
    def self.new_retweet(params, current_user)
      tweet = Tweet.find(params[:tweet_id])
      retweet = current_user.retweets.new(tweet: tweet)

      return ServiceContract.success(retweet) if retweet.save
      
      ServiceContract.error(retweet.errors.full_messages)
    end
  end
end