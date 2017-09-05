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
      array = to_a
      array.select { |line| line.is_a?(Himekaminize::Task) }
    end

    def to_s
      array = to_a
      seq = 0
      array.map do |line|
        if line.is_a?(Himekaminize::Task)
          Himekaminize::Task.new(line, seq)
        else
          line
        end
      end
      .join("\n\r")
    end
  end
end
