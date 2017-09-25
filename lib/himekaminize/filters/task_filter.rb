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

        # attach depth, and parent_seq
        output.map.with_index do |line, index|
          next line unless line.is_a?(Himekaminize::Nodes::Task)
          next line if line.depth == 0
          next line if index == 0
          next line if line.seq == 1
          prev_i = index - 1
          prev_i.downto(0) do |pi|
            next line unless output[pi].is_a?(Himekaminize::Nodes::Task)
            if line.space.length - 4 <= output[pi].space.length && line.space.length - 1
              line.depth = output[pi].depth + 1
              line.parent_seq = output[pi].seq
              next line
            end
          end
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

    end
  end
end
