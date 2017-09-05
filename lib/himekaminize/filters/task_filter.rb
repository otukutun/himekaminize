module Himekaminize
  module Filters
    class TaskFilter < BaseFilter
      # @note Override
      # @param array [Array]
      # @return [Array]
      def call(array)
        seq = 0
        array.map do |line|
          if line.is_a?(String) && line =~ /\A\s*(#{Himekaminize::Task::INCOMPLETE_PATTERN}|#{Himekaminize::Task::COMPLETE_PATTERN})/
            seq += 1
            Himekaminize::Task.new(line, seq)
          else
            line
          end
        end
      end
    end
  end
end
