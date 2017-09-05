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
  end
end
