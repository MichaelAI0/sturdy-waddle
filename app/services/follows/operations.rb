module Follows
  module Operations
    def self.new_follow(params, current_user)
      following = User.find(params[:user_id])
      follow = current_user.followings.new(following: following)

      return ServiceContract.success(follow) if follow.save
      
      ServiceContract.error(follow.errors.full_messages)
    end
  end
end
