require "himekaminize/filters/base_filter"
module Himekaminize
  module Filters
    class HeaderFilter < BaseFilter
      DEFAULT_HEADER_SIZE = 6
      def call(context:, output:)
        @context = context
        output = output.map do |line|
          if line.is_a?(String) && line =~ /\A\s*(#{Himekaminize::Header::PATTERN})/
            Himekaminize::Header.new(line)
          else
            line
          end
        end

        if only_header?
          output = output.select { |line| line.is_a?(Himekaminize::Header) }
        end

        if header_size.present?
          output = output.select { |line|
          (line.is_a?(Himekaminize::Header) && header_size >= line.size) || !line.is_a?(Himekaminize::Header)
          }
        end

        {
          context: context,
          output: output,
        }
      end

      private

      def only_header?
        @context[:only_header].presence || false
      end

      def header_size
        @context[:header_size].presence || DEFAULT_HEADER_SIZE
      end
    end
  end
end
