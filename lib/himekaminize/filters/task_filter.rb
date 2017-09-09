require "himekaminize/filters/base_filter"
module Himekaminize
  module Filters
    class TaskFilter < BaseFilter
      def call(context:, output:)
        seq = 0
        output = output.map do |line|
          if line.is_a?(String) && line =~ /\A\s*(#{Himekaminize::Task::INCOMPLETE_PATTERN}|#{Himekaminize::Task::COMPLETE_PATTERN})/
            seq += 1
            Himekaminize::Task.new(line, seq)
          else
            line
          end
        end
        {
          context: context,
          output: output,
        }
      end
    end
  end
end
