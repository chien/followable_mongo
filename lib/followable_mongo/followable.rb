require 'followable_mongo/following'
require 'followable_mongo/integrations/mongoid'
require 'followable_mongo/integrations/mongo_mapper'

module Mongo
  module Followable
    extend ActiveSupport::Concern

    DEFAULT_FOLLOWS = {
      'followers' => [],
      'count' => 0
    }

    # USed to track all classes that need stats updating in rake task
    FOLLOWABLE = []

    included do
      FOLLOWABLE << self.name

      include ::Mongo::Followable::Following

      if defined?(Mongoid) && defined?(field)
        include ::Mongo::Followable::Integrations::Mongoid
      elsif defined?(MongoMapper)
        include ::Mongo::Followable::Integrations::MongoMapper
      end

      scope :followed_by, lambda { |follower|
        follower_id = follower.is_a?(::BSON::ObjectId) ? follower : follower.id
        where('follows.followers' => follower_id)
      }

      followable_index [['follows.followers', 1], ['_id', 1]], :unique => true
      followable_index [['follows.count', -1]]
    end

    module ClassMethods
      def followed_by?(options)
        validate_and_normalize_follow_options(options)
        self.followed_by(options[:follower_id]).where(:_id => options[:followed_id]).count == 1
      end
    end

    module InstanceMethods
      def follow(options)
        options[:followed_id] = id
        options[:followed] = self
        options[:follower_id] ||= options[:follower].id

        self.class.follow(options)
      end

      def followed_by?(follower)
        follower_id = follower.is_a?(BSON::ObjectId) ? follower : follower.id
        follower_ids.include?(follower_id)
      end

      # Array of follower ids
      def follower_ids
        follows.try(:[], 'followers') || []
      end

      def follows_count
        follows.try(:[], 'count') || 0
      end

      def followers(klass)
        klass.where(:_id => { '$in' =>  follower_ids })
      end

    end
  end
end
