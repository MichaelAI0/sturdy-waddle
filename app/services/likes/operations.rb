module Likes
  module Operations
    def self.new_like(params, current_user)
      tweet = Tweet.find(params[:tweet_id])
      like = current_user.likes.new(tweet: tweet)

      return ServiceContract.success(like) if like.save
      
      ServiceContract.error(like.errors.full_messages)
    end
  end
end
