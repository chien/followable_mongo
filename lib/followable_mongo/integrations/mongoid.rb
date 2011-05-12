module Mongo
  module Followable
    module Integrations
      module Mongoid
        extend ActiveSupport::Concern

        included do
          field :follows, :type => Hash, :default => DEFAULT_FOLLOWS

          class << self
            alias_method :followable_index, :index
          end
        end
        
        module ClassMethods
          def followable_relation(class_name)
            relations.find{ |x, r| r.class_name == class_name }.try(:last)
          end

          def followable_collection
            collection.master.collection
          end

          def followable_foreign_key(metadata)
            metadata.foreign_key.to_s
          end
        end
      end
    end
  end
end
