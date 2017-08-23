module Himekaminize
  class TaskList
    # @param markdown [String]
    def initialize(markdown)
      @markdown = markdown
      to_lines
    end

    # @todo
    # @param markdown [String]
    def to_a
      @lines
    end

    private

    def to_lines
      @lines = @markdown.lines
    end
  end
end
