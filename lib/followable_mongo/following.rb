module Mongo
  module Followable
    module Following
      extend ActiveSupport::Concern

      module ClassMethods
        def unfollow(options)
          options = { :followed => options } unless options.is_a?(Hash)
          options[:unfollow] = true
          follow(options)
        end

        def follow(options)
          validate_and_normalize_follow_options(options)
          query, update = if options[:unfollow]
            unfollow_query_and_update(options)
          else
            new_follow_query_and_update(options)
          end
          begin
            doc = followable_collection.find_and_modify(
              :query => query,
              :update => update,
              :new => true
            )
          rescue Mongo::OperationFailure => e
            doc = nil
          end

          if doc
            options[:followed].write_attribute('follows', doc['follows']) if options[:followed]
            options[:followed] || new(doc)
          else
            false
          end
        end


        private
        def validate_and_normalize_follow_options(options)
          options.symbolize_keys!
          options[:followed_id] = BSON::ObjectId(options[:followed_id]) if options[:followed_id].is_a?(String)
          options[:follower_id] = BSON::ObjectId(options[:follower_id]) if options[:follower_id].is_a?(String)
        end

        def new_follow_query_and_update(options)
          return {
            :_id => options[:followed_id],
            'follows.followers' => { '$ne' => options[:follower_id] }
          }, {
            # then update
            '$addToSet' => { 'follows.followers' => options[:follower_id] },
            '$inc' => {
              'follows.count' => +1
            }
          }
        end

        def unfollow_query_and_update(options)
          return {
            :_id => options[:followed_id],
            'follows.followers' => options[:follower_id]
          }, {
            # then update
            '$pull' => { 'follows.followers' => options[:follower_id] },
            '$inc' => {
              'follows.count' => -1
            }
          }
        end
      end
    end
  end
end
