class FollowBlueprint < Blueprinter::Base
  identifier :id
  fields :follower, :following, :created_at
end
