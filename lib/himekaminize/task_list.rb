module Himekaminize
  class TaskList
    class << self
       # @return [Array<Himekaminize::Filters::BaseFilter>]
       def filters
         @filters ||= [
           ::Himekaminize::Filters::TaskFilter.new
         ]
       end
    end

    # @param markdown [String]
    def initialize(markdown)
      @markdown = markdown
      to_lines
    end

    # @todo
    # @param markdown [Array]
    def to_a
      self.class.filters.inject(@lines) do |result, filter|
        filter.call(result)
      end
    end

    private

    def to_lines
      @lines = @markdown.lines
    end
  end
end
