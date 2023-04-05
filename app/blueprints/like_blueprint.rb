class LikeBlueprint < Blueprinter::Base
  identifier :id
  fields :created_at, :user, :tweet
end
