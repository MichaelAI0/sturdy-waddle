class TweetBlueprint < Blueprinter::Base 
    identifier :id
    fields :content, :created_at, :user, :likes, :retweets
end