require "active_support/concern"

module Himekaminize
  module Filterable
    extend ::ActiveSupport::Concern

    def initialize(markdown)
      @markdown = markdown
      to_lines
      @result ||= Hash.new
    end

    def call
      result[:output] =
        filters.inject(lines) do |output, filter|
          filter.call(output)
        end
    end

    def result
      @result
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
