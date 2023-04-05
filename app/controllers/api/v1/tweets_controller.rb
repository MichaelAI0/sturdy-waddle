module Api
  module V1
    class TweetsController < Api::V1::ApplicationController
      def create
        result = Tweets::Operations.new_tweet(params, @current_user)
        render_error(errors: result.errors.all, status: 400) and return unless result.success?

        tweet = result.payload

        payload = {
          tweet: TweetBlueprint.render_as_hash(tweet),
          status: 201
        }
        render_success(payload: payload)
      end

      def index
        tweets = Tweet.includes(:user, :likes, :retweets).order(created_at: :desc)

        payload = {
          tweets: TweetBlueprint.render_as_hash(tweets),
          status: 200
        }
        render_success(payload: payload)
      end

      def like
        tweet = Tweet.find(params[:id])
        like = Like.find_or_initialize_by(user_id: @current_user.id, tweet_id: tweet.id)
        like.save!

        payload = {
          tweet: TweetBlueprint.render_as_hash(tweet),
          status: 200
        }
        render_success(payload: payload)
      end

      def unlike
        tweet = Tweet.find(params[:id])
        like = Like.find_by(user_id: @current_user.id, tweet_id: tweet.id)
        like.destroy!

        payload = {
          tweet: TweetBlueprint.render_as_hash(tweet),
          status: 200
        }
        render_success(payload: payload)
      end

      def retweet
        tweet = Tweet.find(params[:id])
        retweet = Retweet.find_or_initialize_by(user_id: @current_user.id, tweet_id: tweet.id)
        retweet.save!

        payload = {
          tweet: TweetBlueprint.render_as_hash(tweet),
          status: 200
        }
        render_success(payload: payload)
      end

      def unretweet
        tweet = Tweet.find(params[:id])
        retweet = Retweet.find_by(user_id: @current_user.id, tweet_id: tweet.id)
        retweet.destroy!

        payload = {
          tweet: TweetBlueprint.render_as_hash(tweet),
          status: 200
        }
        render_success(payload: payload)
      end
    end
  end
end
