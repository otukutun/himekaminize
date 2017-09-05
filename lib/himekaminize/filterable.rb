require "active_support/concern"

module Himekaminize
  module Filterable
    extend ::ActiveSupport::Concern

    def initialize(markdown)
      @markdown = markdown
      to_lines
    end

    def to_a
      filters.inject(lines) do |result, filter|
        filter.call(result)
      end
    end

    private

    def filters
      @filters ||= self.class.filter_classes.map(&:new)
    end

    def markdown
      @markdown
    end

    def lines
      @lines
    end

    def to_lines
      @lines = markdown.lines
    end

    module ClassMethods
      def filter_classes
        raise ::NotImplementedError
      end
    end
  end
end
