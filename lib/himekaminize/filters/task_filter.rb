module Himekaminize
  module Filters
    class TaskFilter < BaseFilter
      # @note Override
      # @param array [Array]
      # @return [Array]
      def call(array)
        array
          .select { |line| line.is_a?(String) && line =~ /\A\s*(#{Himekaminize::Task::INCOMPLETE_PATTERN}|#{Himekaminize::Task::COMPLETE_PATTERN})/ }
          .map.with_index {|n, idx| Himekaminize::Task.new(n, idx + 1)}
      end

    end
  end
end
