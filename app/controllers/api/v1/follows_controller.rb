module Api
  module V1
    class FollowsController < Api::V1::ApplicationController
      before_action :authenticate_user!
      before_action :set_user

      def create
        follow = Follow.new(follower: current_user, following: @user)
        if follow.save
          render_success(payload: { follow: FollowBlueprint.render_as_hash(follow) }, status: :created)
        else
          render_error(errors: follow.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def destroy
        follow = Follow.find_by(follower: current_user, following: @user)
        if follow.destroy
          render_success(payload: { message: 'Unfollowed successfully' }, status: :ok)
        else
          render_error(errors: follow.errors.full_messages, status: :unprocessable_entity)
        end
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end
    end
  end
end
