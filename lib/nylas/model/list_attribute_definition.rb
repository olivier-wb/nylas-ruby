# frozen_string_literal: true

module Nylas
  module Model
    # Allows models to have an attribute which is a lists of another type of thing
    class ListAttributeDefinition
      attr_accessor :type_name, :exclude_when, :default

      def initialize(type_name:, exclude_when:, default:)
        self.type_name = type_name
        self.exclude_when = exclude_when
        self.default = default
      end

      def cast(list)
        return default if list.nil? || list.empty?

        as_array(list).map { |item| type.cast(item) }
      end

      def as_array(list)
        list.is_a?(Array) ? list : [list]
      end

      def serialize(list)
        list = default if list.nil? || list.empty?
        as_array(list).map { |item| type.serialize(item) }
      end

      def type
        Types.registry[type_name]
      end
    end
  end
end
