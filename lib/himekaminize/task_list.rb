require "active_support/core_ext/object"
module Himekaminize
  class TaskList
    include ::Himekaminize::Filterable
    class << self
       # @return [Array<Himekaminize::Filters::BaseFilter>]
       def filter_classes
         @filter_classes ||= [
           ::Himekaminize::Filters::TaskFilter
         ]
       end
    end

    def to_task_list
      array = result.try(:output) || call
      result[:task_list] = array.select { |line| line.is_a?(Himekaminize::Task) }
    end

    def update_task_status(sequence, status)
      return false unless ::Himekaminize::Task::STATUSES.include?(status)
      result[:task_list] = result.try(:task_list) || to_task_list
      if sequence.is_a?(Integer) && sequence > 0 && (1..result[:task_list].count).cover?(sequence)
        result[:task_list][sequence - 1].status = status
      else
        false
      end
      true
    end

    def to_s
      array = result.try(:output) || call
      seq = 0
      array.map do |line|
        if line.is_a?(::Himekaminize::Task)
          line.to_s + "\n\r"
        else
          line
        end
      end
      .join('')
    end
  end
end
