require "himekaminize/filters/base_filter"
module Himekaminize
  module Filters
    class TaskFilter < BaseFilter
      def call(context:, output:)
        seq = 0
        @context = context
        output = output.map do |line|
          if line.is_a?(String) && line =~ /\A\s*(#{Himekaminize::Nodes::Task::INCOMPLETE_PATTERN}|#{Himekaminize::Nodes::Task::COMPLETE_PATTERN})/
            seq += 1
            Himekaminize::Nodes::Task.new(line, seq)
          else
            line
          end
        end

        # Attach depth, and parent_seq
        output.map.with_index do |line, index|
          next line if !line.is_a?(Himekaminize::Nodes::Task) || index == 0 || line.none_parent?
          prev_i = index - 1
          next attach_parent_task(output, line, prev_i)
        end

        if only_task_list?
          output = output.select { |line| line.is_a?(Himekaminize::Nodes::Task) }
        end

        if update_task_status_list.present?
          seq = 1
          update_task_status_list.each do |v|
            output = output.map do |line|
              if line.is_a?(Himekaminize::Nodes::Task) && line.seq == v[:seq]
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

      def attach_parent_task(output, task, prev_i)
        prev_i.downto(0) do |pi|
          return task unless output[pi].is_a?(Himekaminize::Nodes::Task)
          if task.parent?(output[pi])
            task.depth = output[pi].depth + 1
            task.parent_seq = output[pi].seq
            return task
          end
        end
        task
      end
    end
  end
end
