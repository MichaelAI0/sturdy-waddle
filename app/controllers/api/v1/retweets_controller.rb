module Api
  module V1
    class RetweetsController < Api::V1::ApplicationController
      before_action :authenticate_user!
      before_action :set_tweet

      def create
        retweet = Retweet.new(user: current_user, tweet: @tweet)
        if retweet.save
          render_success(payload: { retweet: RetweetBlueprint.render_as_hash(retweet) }, status: :created)
        else
          render_error(errors: retweet.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def destroy
        retweet = Retweet.find_by(user: current_user, tweet: @tweet)
        if retweet.destroy
          render_success(payload: { message: 'Retweet removed successfully' }, status: :ok)
        else
          render_error(errors: retweet.errors.full_messages, status: :unprocessable_entity)
        end
      end

      private

      def set_tweet
        @tweet = Tweet.find(params[:tweet_id])
      end
    end
  end
end