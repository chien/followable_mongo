module Mongo
  module Followable
    module Integrations
      module MongoMapper
        extend ActiveSupport::Concern

        included do
          key :follows, Hash, :default => DEFAULT_FOLLOWS
          
          class << self
            alias_method :followable_index, :ensure_index
            alias_method :followable_collection, :collection
          end
        end

        module ClassMethods
          def followable_relation(class_name)
            associations.find{ |x, r| r.class_name == class_name }.try(:last)
          end
          
          def followable_foreign_key(metadata)
            (metadata.options[:in] || "#{metadata.name}_id").to_s
          end
        end
      end
    end
  end
end
