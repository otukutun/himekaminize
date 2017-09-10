require "active_support/concern"
module Himekaminize
  module Filterable
    extend ::ActiveSupport::Concern

    def initialize(default_context = {})
      @default_context = default_context
    end

    def call(markdown, context = {})
      @markdown = markdown
      to_lines
      @result ||= Hash.new
      context = default_context.merge(context)

      @result = filters.inject(context: context, output: lines) do |output, filter|
        filter.call(output)
      end

      @result
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

    def context
      @context
    end

    def default_context
      @default_context
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
