module Himekaminize
  module Nodes
    class Header < BaseNode

      PATTERN = /\#{1,6}/
      attr_accessor :space, :name, :level, :size

      def initialize(line)
        @space, @level, @name = split_name_and_level(line)
        @size = count_size
      end

      def to_s
        sprintf("%s%s%s\n", @space, @level, @name)
      end

      private

      def split_name_and_level(line)
        /\A(\s*)(#{PATTERN})(.*)/.match(line) do |m|
          [m[1], m[2], m[3]]
        end
      end

      def count_size
        @level.length
      end
    end
  end
end
