module Api
  module V1
    class LikesController < Api::V1::ApplicationController
      before_action :authenticate_user!
      before_action :set_tweet

      def create
        like = Like.new(user: current_user, tweet: @tweet)
        if like.save
          render_success(payload: { like: LikeBlueprint.render_as_hash(like) }, status: :created)
        else
          render_error(errors: like.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def destroy
        like = Like.find_by(user: current_user, tweet: @tweet)
        if like.destroy
          render_success(payload: { message: 'Like removed successfully' }, status: :ok)
        else
          render_error(errors: like.errors.full_messages, status: :unprocessable_entity)
        end
      end

      private

      def set_tweet
        @tweet = Tweet.find(params[:tweet_id])
      end
    end
  end
end
