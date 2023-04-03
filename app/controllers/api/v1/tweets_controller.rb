module Api 
  module V1 
    class TweetsController < Api::V1::ApplicationController
      def create
        result = Tweets::Operations.new_tweet(params, @current_user)
        render_error(errors: result.errors.all, status: 400) and return unless result.success?
        payload = {
          tweet: TweetBlueprint.render_as_hash(result.payload),
          status: 201
        }
        render_success(payload: payload)
      end
          
      def index
        tweets = @current_user.tweets # Get all tweets associated with the current user
        payload = {
          tweets: TweetBlueprint.render_as_hash(tweets),
          status: 200
        }
        render_success(payload: payload)
      end
    end
  end
end
