module Neoid
  module ModelAdditions
    module ClassMethods
      def neoidable(options)
        @config = Neoid::ModelConfig.new
        yield(@config) if block_given?
        @neoidable_options = options
      end
    
      def neoidable_options
        @neoidable_options
      end
    end
  
    module InstanceMethods
      def to_neo
        {}
      end
    
      def neo_index_name
        @index_name ||= "#{self.class.name.tableize}_index"
      end

      protected
      def neo_properties_to_hash(*property_list)
        property_list.flatten.inject({}) { |all, property|
          all[property] = self.send(property)
          all
        }
      end

      private
      def _neo_representation
        @_neo_representation ||= begin
          results = neo_find_by_id
          if results
            neo_load(results.first['self'])
          else
            node = neo_create
            node
          end
        end
      end
    end
  end
end