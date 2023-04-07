class TweetBlueprint < Blueprinter::Base
  identifier :id
  fields :content, :likes, :retweets, :user_id
end
