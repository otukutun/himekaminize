module Himekaminize
  module Filters
    class TaskFilter < BaseFilter

      INCOMPLETE_PATTERN = /[-+*]\s\[\s\]/
      COMPLETE_PATTERN = /[-+*]\s\[[xX]\]/

      # @note Override
      # @param array [Array]
      # @return [Array]
      def call(array)
        array.select { |line| line.is_a?(String) && line =~ /\A\s*(#{INCOMPLETE_PATTERN}|#{COMPLETE_PATTERN})/ }
      end
    end
  end
end
