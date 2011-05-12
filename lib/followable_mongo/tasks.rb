module Mongo
  module Followable
    module Tasks

      # Set counters to 0 for uninitialized followable objects
      def self.init_stats(log = false)
        FOLLOWABLE.each do |class_name|
          klass = class_name.constantize
          puts "Init stats for #{class_name}" if log
          klass.collection.update({:follows => nil}, {
            '$set' => { :follows => DEFAULT_FOLLOWS }
          }, {
            :safe => true,
            :multi => true
          })
        end
      end

      # Re-generate follow counters
      def self.remake_stats(log = false)
        remake_stats_for_all_followable_classes(log)
      end

      def self.remake_stats_for_all_followable_classes(log)
        FOLLOWABLE.each do |class_name|
          klass = class_name.constantize
          puts "Generating stats for #{class_name}" if log
          klass.all.each{ |doc|
            remake_stats_for(doc)
          }
        end
      end

      def self.remake_stats_for(doc)
        count = doc.follower_ids.length
        query = {:_id => doc.id}
        update = {'$set' => {'follows.count' => count}}
        doc = doc.class.followable_collection.find_and_modify(
              :query => query,
              :update => update,
              :new => false
        )
      end

      private_class_method  :remake_stats_for,
                            :remake_stats_for_all_followable_classes

    end
  end
end