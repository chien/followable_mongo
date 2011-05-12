module Mongo
  module Follower
    extend ActiveSupport::Concern

    included do
      scope :following, lambda { |followed| where(:_id => { '$in' =>  followed.follower_ids }) }
    end

    module InstanceMethods

      def following?(options)
        unless options.is_a?(Hash)
          followed_class = options.class
          followed_id = options.id
        else
          followed = options[:followed]
          if followed
            followed_class = followed.class
            followed_id = followed.id
          else
            followed_class = options[:followed_class]
            followed_id = options[:followed_id]
          end
        end

        followed_class.followed_by?(:follower_id => id, :followed_id => followed_id)
      end

      def unfollow(options)
        unless options.is_a?(Hash)
          options = { :followed => options }
        end
        options[:unfollow] = true
        follow(options)
      end

      def follow(options)
        if options.is_a?(Hash)
          followed = options[:followed]
        else
          followed = options
          options = { :followed => followed}
        end

        if followed
          options[:followed_id] = followed.id
          followed_class = followed.class
        else
          followed_class = options[:followed_class]
        end

        options[:follower] = self
        options[:follower_id] = id

        (followed || followed_class).follow(options)
      end
    end

  end
end
