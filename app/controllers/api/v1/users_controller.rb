# frozen_string_literal: true

module Api
  module V1
    # Handles endpoints related to users
    class UsersController < Api::V1::ApplicationController
      skip_before_action :authenticate, only: %i[login create]

      def login
        result = BaseApi::Auth.login(params[:email], params[:password], @ip)
        unless result.success?
          render_error(errors: "User not authenticated", status: 401) and return
        end

        payload = {
          user:
            UserBlueprint.render_as_hash(result.payload[:user], view: :login),
          token: TokenBlueprint.render_as_hash(result.payload[:token]),
          status: 200
        }
        render_success(payload: payload)
      end

      # YOU SHOULD CHECK IF THE USER IS PRESENT OR NOT!!!!
      def logout
        if @current_user.present?
          result = BaseApi::Auth.logout(@current_user, @token)
          unless result.success?
            render_error(
              errors: "There was a problem logging out",
              status: 401
            ) and return
          end

          render_success(payload: "You have been logged out", status: 200)
        else
          render_error(errors: "Unauthorized", status: 401)
        end
      end

      def create
        result = BaseApi::Users.new_user(params)
        unless result.success?
          render_error(
            errors: "There was a problem creating a new user",
            status: 400
          ) and return
        end
        payload = {
          user: UserBlueprint.render_as_hash(result.payload, view: :normal)
        }
        #  TODO: Invite user to accept invitation via registered email
        render_success(payload: payload, status: 201)
      end

      def me
        render_success(
          payload: UserBlueprint.render_as_hash(@current_user),
          status: 200
        )
      end

      def update
        result = BaseApi::Users.update_user(@current_user.id, user_params)
        unless result.success?
          render_error(
            errors: "There was a problem updating the user",
            status: 400
          ) and return
        end
        payload = {
          user: UserBlueprint.render_as_hash(result.payload, view: :normal)
        }
        render_success(payload: payload, status: 200)
      end

      def validate_invitation
        user =
          User
            .invite_token_is(params[:invitation_token])
            .invite_not_expired
            .first

        if user.nil?
          render_error(errors: { validated: false, status: 401 }) and return
        end
        render_success(payload: { validated: true, status: 200 })
      end

      private

      def user_params
        params.permit(
          :first_name,
          :last_name,
          :email,
          :phone,
          :country,
          :street,
          :city,
          :state,
          :postal_code
        )
      end
    end
  end
end
