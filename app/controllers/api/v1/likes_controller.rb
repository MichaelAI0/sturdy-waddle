module Api
  module V1
    class LikesController < Api::V1::ApplicationController
      before_action :set_tweet

      def create
        if @tweet.user == @current_user
          # User is trying to like their own tweet
          render_error(
            errors: "You cannot like your own tweet",
            status: :unprocessable_entity
          )
          return
        end

        like = Like.new(user: @current_user, tweet: @tweet)
        if like.save
          render_success(
            payload: {
              like: LikeBlueprint.render_as_hash(like)
            },
            status: :created
          )
        else
          render_error(
            errors: like.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def destroy
        like = Like.find_by(user: @current_user, tweet: @tweet)
        if like.destroy
          render_success(
            payload: {
              message: "Like removed successfully"
            },
            status: :ok
          )
        else
          render_error(
            errors: like.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      private

      def set_tweet
        @tweet = Tweet.find(params[:id])
      end
    end
  end
end
