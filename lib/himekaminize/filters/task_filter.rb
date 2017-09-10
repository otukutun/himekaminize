require "himekaminize/filters/base_filter"
module Himekaminize
  module Filters
    class TaskFilter < BaseFilter
      def call(context:, output:)
        seq = 0
        @context = context
        output = output.map do |line|
          if line.is_a?(String) && line =~ /\A\s*(#{Himekaminize::Task::INCOMPLETE_PATTERN}|#{Himekaminize::Task::COMPLETE_PATTERN})/
            seq += 1
            Himekaminize::Task.new(line, seq)
          else
            line
          end
        end

        if only_task_list?
          output = output.select { |line| line.is_a?(Himekaminize::Task) }
        end

        if update_task_status_list.present?
          seq = 1
          update_task_status_list.each do |v|
            output = output.map do |line|
              if line.is_a?(Himekaminize::Task) && line.sequence == v[:sequence]
                line.update_status(v[:status].to_sym)
                line
              else
                line
              end
            end
          end

        end

        {
          context: context,
          output: output,
        }
      end

      private

      def only_task_list?
        @context[:only_task_list].presence || false
      end

      def update_task_status_list
        @context[:update_task_status_list].presence || {}
      end
    end
  end
end
